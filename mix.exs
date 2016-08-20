defmodule MeetYourDeveloper.Mixfile do
  use Mix.Project

  def project do
    [app: :meet_your_developer,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:cowboy, :exfswatch, :logger, :plug],
     mod: {MeetYourDeveloper, []}]
  end

  defp deps do
    [{:cowboy,    "~> 1.0.0"},
     {:earmark,   "~> 1.0.1"},
     {:exfswatch, "~> 0.1.0"},
     {:plug,      "~> 1.0"}]
  end
end
