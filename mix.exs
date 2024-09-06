defmodule AshAi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ash_ai,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ash_json_api, "~> 1.0"},
      {:openai_ex, "~> 0.8"},
      {:ash, "~> 3.0"},
      {:open_api_spex, "~> 3.0"},
      {:igniter, "~> 0.3"},
      {:mock, "~> 0.3.0", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
