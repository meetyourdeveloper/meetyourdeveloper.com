defmodule MeetYourDeveloper.Watcher do
  use ExFSWatch, dirs: ["lib/web"]

  alias MeetYourDeveloper.Builder

  def start_link do
    Builder.build
    __MODULE__.start
  end
  
  def callback(_file_path, _events), do: Builder.build
end
