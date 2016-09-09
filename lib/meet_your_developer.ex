defmodule MeetYourDeveloper do
  @moduledoc """
  Runs the site, both locally and on a server.

  Builer is only started when running without
  the "FAST" env var (usually localhost).
  """

  use Application

  alias MeetYourDeveloper.Builder
  alias MeetYourDeveloper.Router

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Builder.build

    children = case System.get_env("FAST") do
      true -> [worker(Router, [])]

      _ -> [worker(ExFSWatch.Supervisor, []),
            worker(Builder, []),
            worker(Router, [])]
    end

    opts = [strategy: :one_for_one, name: MeetYourDeveloper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
