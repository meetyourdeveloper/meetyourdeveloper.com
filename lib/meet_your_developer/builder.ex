defmodule MeetYourDeveloper.Builder do
  use ExFSWatch, dirs: ["lib/web"]

  require EEx

  @src  "lib/web"
  @dest "docs"

  def start_link, do: build && __MODULE__.start

  def callback(_file_path, _events), do: build

  def build, do: [:clean, :cname, :assets, :styles, :scripts, :pages, :blog] |> Enum.map(&build/1)

  defp build(:clean), do: File.rm_rf(@dest) && File.mkdir(@dest)

  defp build(:cname), do: "#{@src}/CNAME" |> File.cp("#{@dest}/CNAME")

  defp build(:assets), do: "#{@src}/assets" |> File.cp_r("#{@dest}/assets")

  defp build(:styles), do: "#{@dest}/styles.css" |> File.write(concat(:styles))

  defp build(:scripts), do: "#{@dest}/scripts.js" |> File.write(concat(:scripts))

  defp build(:pages) do
    "#{@src}/pages" |> File.cp_r("#{@dest}")
    "#{@src}/pages/**/*.html" |> Path.wildcard |> Enum.each(&render_page/1)
  end

  defp build(:blog) do
    File.mkdir "#{@dest}/posts"
    "#{@src}/posts/*.md" |> Path.wildcard |> Enum.each(&render_post/1)
  end

  defp concat(:styles),  do: "#{@src}/styles/**/*.css" |> Path.wildcard |> concat
  defp concat(:scripts), do: "#{@src}/scripts/**/*.js" |> Path.wildcard |> concat
  defp concat(files),    do: files |> Enum.reduce("", &(&2 <> File.read!(&1)))

  defp render_page(path) do
    path
    |> String.replace("#{@src}/pages", "#{@dest}")
    |> File.write(path |> File.read! |> template)
  end

  defp render_post(path) do
    path
    |> String.replace(@src, @dest)
    |> String.replace(".md", ".html")
    |> File.write(path |> File.read! |> Earmark.to_html |> template)
  end

  EEx.function_from_file :def, :template, "#{@src}/layout.eex", [:content]
end
