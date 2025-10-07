import Config

config :elixir_jwt_auth_protected_route,
  port: System.get_env("PORT", "4000")
