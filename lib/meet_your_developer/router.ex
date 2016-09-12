defmodule MeetYourDeveloper.Router do
  @moduledoc """
  Handles routing to priv/static.

  If a file is not found for a given route, it attempts to find
  <path>/index.html before returning a 404.
  """

  use Plug.Router

  alias Plug.Adapters.Cowboy

  plug Plug.Logger
  plug Plug.Static, at: "/", from: "priv/static"
  plug :match
  plug :dispatch

  def start_link, do: Cowboy.http __MODULE__, [], port: port

  defp port,        do: port System.get_env "PORT"
  defp port(nil),   do: 7976
  defp port(value), do: value |> String.to_integer

  get _ do
    conn
    |> set_index_path
    |> send_index
  end

  defp join_path_info(conn) do
    conn.path_info
    |> Enum.join("/")
  end

  defp send_index(conn) do
    conn
    |> send_index(File.exists?(conn.assigns[:index_path]))
  end

  defp send_index(conn, true) do
    conn
    |> send_file(200, conn.assigns[:index_path])
  end

  defp send_index(conn, false) do
    conn
    |> send_resp(404, "Not found")
  end

  defp set_index_path(conn) do
    conn
    |> assign(:index_path, index_path(conn))
  end

  defp index_path(conn) do
    "priv/static/" <> join_path_info(conn) <> "/index.html"
  end
end
