defmodule MultiTenancex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :multi_tenancex,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # ExCoveralls config
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MultiTenancex.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:ci), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Default Phoenix stuff
      {:cowboy, "~> 1.1.2"},
      {:gettext, "~> 0.13.1"},
      {:phoenix, "~> 1.3.2", override: true},
      {:phoenix_ecto, "~> 3.3.0"},
      {:postgrex, ">= 0.13.3"},
      {:phoenix_pubsub, "~> 1.0.2"},

      # Frontend
      {:phoenix_html, "~> 2.10.4"},
      {:phoenix_live_reload, "~> 1.1.1", only: :dev},

      # Authentication
      {:comeonin, "~> 4.1.1"},
      {:bcrypt_elixir, "~> 0.12"},
      {:guardian, "~> 1.0"},

      # Code analysis
      {:credo, "~> 0.9.0", only: [:dev, :test]},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},

      # Code documentation
      {:ex_doc, "~> 0.16.4", only: :dev, runtime: false},

      # Random
      {:timex, "~> 3.2.1"},

      # Testing and seeding data
      {:faker, "~> 0.9.0"},
      {:excoveralls, "~> 0.7.3", only: [:test]},
      {:exvcr, "~> 0.9.0", only: [:test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
