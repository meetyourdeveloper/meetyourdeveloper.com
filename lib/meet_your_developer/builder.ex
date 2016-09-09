defmodule MeetYourDeveloper.Builder do
  @moduledoc """
  Builds lib/web into priv/static. Watches for changes, then rebuilds.
  """

  require EEx

  use ExFSWatch, dirs: ["lib/web"]

  @src "lib/web"
  @dest "priv/static"
  @pages "#{@src}/pages/**/*.html" |> Path.wildcard
  @posts "#{@src}/posts/*.md" |> Path.wildcard

  @doc """
  Starts watching lib/web for changes, then call callback/2.
  """
  def start_link, do: __MODULE__.start

  @doc """
  Called when lib/web changes, triggering a rebuild.
  """
  def callback(_file_path, _events), do: build

  @doc """
  Calls each specific build/1 function.
  """
  def build do
    [:clean, :assets, :pages, :posts, :archive, :feed, :home]
    |> Enum.map(&build/1)
  end

  defp build(:clean) do
    File.rm_rf(@dest) && File.mkdir_p(@dest)
    "#{@src}/pages" |> File.cp_r("#{@dest}")
    File.mkdir "#{@dest}/posts"
  end

  defp build(:assets), do: "#{@src}/assets" |> File.cp_r("#{@dest}/assets")
  defp build(:pages), do: @pages |> Enum.each(&render_page/1)
  defp build(:posts), do: @posts |> Enum.each(&render_post/1)

  defp build(:archive) do
  end

  defp build(:feed) do
  end

  defp build(:home) do
  end

  # Helpers

  defp render_page(path) do
    path
    |> String.replace("#{@src}/pages", "#{@dest}")
    |> File.write(path |> File.read! |> layout)
  end

  defp render_post(path) do
    {_, data} = path |> parse
    path
    |> String.replace(@src, @dest)
    |> String.replace(".md", ".html")
    |> File.write(data |> layout)
  end

  defp parse(path) do
    [meta, data] = path |> File.read! |> String.split("+++")
    {YamlElixir.read_from_string(meta), Earmark.to_html(data)}
  end

  EEx.function_from_file(:def, :layout,
    "lib/web/templates/layout.eex", [:content])
end

#   defp build(:rss) do
#     "#{@dest}/posts.rdf"
#     |> File.write("#{@src}/templates/rss.eex" |> File.read!)
#   end
