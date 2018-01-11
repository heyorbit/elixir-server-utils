defmodule ServerUtils.Mixfile do
  use Mix.Project

  def project do
    [
      app: :server_utils,
      version: "0.0.2",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.8", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:plug, "~> 1.4"},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:sentry, "~> 6.0.5"},
      {:joken, "~> 1.5"},
      {:exjsx, "~> 4.0"},
    ]
  end

  defp aliases do
    [
      "compile": ["compile --warnings-as-errors"],
      "coveralls": ["coveralls.html --umbrella"],
      "coveralls.html": ["coveralls.html --umbrella"],
    ]
  end
end
