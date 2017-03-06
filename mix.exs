defmodule Bugsnex.Mixfile do
  use Mix.Project

  def project do
    [app: :bugsnex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :inets, :ssl], mod: {Bugsnex, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:credo, "~> 0.5", only: [:dev, :test]},
     {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
     {:ex_doc, "~> 0.14", only: :dev, runtime: false},
     {:poison, "~> 3.0"}]
  end

  defp description do
    """
    Error reporter for Bugsnag API
    """
  end

  defp package do
    [name: :bugsnex,
     files: ~w(lib mix.exs README.md),
     maintainers: ["Ludovic Vielle"],
     licenses: ["MIT License"],
     links: %{"GitHub" => "https://github.com/Lukkor/bugsnex"}]
  end
end
