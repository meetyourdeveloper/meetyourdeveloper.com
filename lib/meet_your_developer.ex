defmodule MeetYourDeveloper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    MeetYourDeveloper.Builder.build

    children = case System.get_env("FAST") do
      true -> [worker(MeetYourDeveloper.Router, [])]
      _ -> [worker(ExFSWatch.Supervisor, []),
            worker(MeetYourDeveloper.Builder, []),
            worker(MeetYourDeveloper.Router, [])]
    end

    opts = [strategy: :one_for_one, name: MeetYourDeveloper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
