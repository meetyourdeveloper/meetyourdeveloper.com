defmodule MeetYourDeveloper.Builder do
  require EEx

  @src  "lib/web"
  @dest "priv/static"

  def build, do: [:clean, :assets, :styles, :scripts, :pages, :blog] |> Enum.map(&(build(&1)))

  defp build(:clean) do
    File.rm_rf @dest
    File.mkdir @dest
  end

  defp build(:assets), do: "#{@src}/assets" |> File.cp_r!("#{@dest}/assets")

  defp build(:styles), do: "#{@src}/styles/**/*.css" |> Path.wildcard |> concat("#{@dest}/styles.css")

  defp build(:scripts), do: "#{@src}/scripts/**/*.js" |> Path.wildcard |> concat("#{@dest}/scripts.js")

  defp build(:pages) do
    "#{@src}/pages" |> File.cp_r!("#{@dest}")
    "#{@src}/pages/**/*.html"
    |> Path.wildcard
    |> Enum.each(fn path ->
      {:ok, file} = File.open String.replace(path, "#{@src}/pages", "#{@dest}"), [:write]
      IO.binwrite(file, path |> File.read! |> template)
      File.close file
    end)
  end

  defp build(:blog) do
    File.mkdir "#{@dest}/posts"
    "#{@src}/posts/*.md"
    |> Path.wildcard
    |> Enum.each(fn path ->
      destination = path |> String.replace(@src, @dest) |> String.replace(".md", ".html")
      {:ok, file} = File.open destination, [:write]
      IO.binwrite(file, path |> File.read! |> Earmark.to_html |> template)
      File.close file
    end)
  end

  defp concat(from, to) do
    File.touch to
    {:ok, file} = File.open to, [:write]
    from |> Enum.each(&(IO.binwrite(file, File.read!(&1))))
    File.close file
  end

  EEx.function_from_file :def, :template, "#{@src}/layout.eex", [:content]
end
