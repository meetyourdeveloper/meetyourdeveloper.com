defmodule MeetYourDeveloper do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(MeetYourDeveloper.Watcher, []),
      worker(MeetYourDeveloper.Router, [])
    ]

    opts = [strategy: :one_for_one, name: MeetYourDeveloper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
