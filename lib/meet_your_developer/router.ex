defmodule MeetYourDeveloper.Router do
  use Plug.Router

  @public "priv/static/"

  plug Plug.Logger
  plug Plug.Static, at: "/", from: @public
  plug :match
  plug :dispatch

  def start_link, do: {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], port: port(System.get_env("PORT"))

  defp port(nil), do: 7976
  defp port(value), do: value |> String.to_integer

  get _, do: conn |> set_index_path |> send_index

  defp join_path_info(conn), do: conn.path_info |> Enum.join("/")

  defp send_index(conn),        do: conn |> send_index(File.exists?(conn.assigns[:index_path]))
  defp send_index(conn, true),  do: conn |> send_file(200, conn.assigns[:index_path])
  defp send_index(conn, false), do: conn |> send_resp(404, "Not found")

  defp set_index_path(conn), do: conn |> assign(:index_path, @public <> join_path_info(conn) <> "/index.html")
end
