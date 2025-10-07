defmodule ElixirJwtAuthProtectedRoute.Repo do
  use Ecto.Repo,
    otp_app: :elixir_jwt_auth_protected_route,
    adapter: Ecto.Adapters.SQLite3
end
