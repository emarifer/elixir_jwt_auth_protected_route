import Config

config :elixir_jwt_auth_protected_route,
  ecto_repos: [ElixirJwtAuthProtectedRoute.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :elixir_jwt_auth_protected_route, ElixirJwtAuthProtectedRoute.Repo,
  database: Path.expand("../user_auth.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :elixir_jwt_auth_protected_route,
  jwt_secret: System.get_env("JWT_SECRET") || "your-strong-secret-key"

config :logger, :console,
  metadata: [:mfa],
  format: "$time [$level] [$metadata] $message\n",
  truncate: :infinity,
  level: :debug
