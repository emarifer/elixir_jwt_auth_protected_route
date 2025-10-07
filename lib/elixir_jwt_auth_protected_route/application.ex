defmodule ElixirJwtAuthProtectedRoute.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:elixir_jwt_auth_protected_route, :port)

    children = [
      # Starts a worker by calling: ElixirJwtAuthProtectedRoute.Worker.start_link(arg)
      # {ElixirJwtAuthProtectedRoute.Worker, arg}
      ElixirJwtAuthProtectedRoute.Repo,
      {Bandit, scheme: :http, plug: ElixirJwtAuthProtectedRoute.Web.Router, port: port}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirJwtAuthProtectedRoute.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
