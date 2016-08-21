defmodule MeetYourDeveloper.Mixfile do
  use Mix.Project

  def project do
    [app: :meet_your_developer,
     name: "Meet Your Developer",
     description: "Teaching software developers to market themselves effectively.",
     source_url: "https://github.com/meetyourdeveloper/meetyourdeveloper.github.io",
     homepage_url: "http://meetyourdeveloper.com",
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "readme", extras: ["README.md"]]]
  end

  def application do
    [applications: [:cowboy, :logger, :plug],
     mod: {MeetYourDeveloper, []}]
  end

  defp deps do
    [{:cowboy,    "~> 1.0.0"},
     {:earmark,   "~> 1.0.1"},
     {:ex_doc,    "~> 0.12"},
     {:exfswatch, "~> 0.1.0"},
     {:plug,      "~> 1.0"}]
  end
end
