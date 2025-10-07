defmodule ElixirJwtAuthProtectedRoute.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_jwt_auth_protected_route,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirJwtAuthProtectedRoute.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:bandit, "~> 1.8"},
      {:ecto_sql, "~> 3.13"},
      {:ecto_sqlite3, "~> 0.22.0"},
      {:exsync, "~> 0.4.1", only: :dev},
      {:joken, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:argon2_elixir, "~> 4.1"}
    ]
  end

  # NOTE: `jason` is a dependency of the Erlang `jose` library,
  # which is itself a dependency of `Joken` (a transitive dependency).
  # It is not installed automatically, so it must be declared specifically.
  # See: https://hexdocs.pm/jose/readme.html#installation

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
