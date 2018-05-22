defmodule ServerUtils.Mixfile do
  @moduledoc false
  use Mix.Project

  @version "0.2.4"

  def project do
    [
      app: :server_utils,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: description(),
      docs: [
        source_ref: "v#{@version}",
        main: "installation",
        extra_section: "README",
        formatters: ["html", "epub"],
        extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp package do
    [
      name: "server_utils",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Adrián Quintás"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/orbitdigital/elixir-server-utils"}
    ]
  end

  defp description do
    "Server utils to automate common tasks like pagination or authentication"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.8", only: :test},
      {:mock, "~> 0.3", only: :test},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:plug, "~> 1.5.1"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:sentry, "~> 6.2"},
      {:joken, "~> 1.5"},
      {:exjsx, "~> 4.0"},
      {:git_hooks, "~> 0.1.1"}
    ]
  end

  defp aliases do
    [
      compile: ["compile --warnings-as-errors"],
      coveralls: ["coveralls.html --umbrella"],
      "coveralls.html": ["coveralls.html --umbrella"]
    ]
  end
end
