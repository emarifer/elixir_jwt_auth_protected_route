defmodule ElixirJwtAuthProtectedRoute.Web.Router do
  require Logger
  use Plug.Router
  use Plug.ErrorHandler

  alias ElixirJwtAuthProtectedRoute.Web.User
  alias ElixirJwtAuthProtectedRoute.Web.User.Html, as: UserHtml
  alias ElixirJwtAuthProtectedRoute.Web.User.Auth, as: UserAuth
  alias ElixirJwtAuthProtectedRoute.Web.User.Message, as: UserMessage

  plug(Plug.Logger, log: :debug)
  plug(Plug.Static, at: "/static/", from: {:elixir_jwt_auth_protected_route, "priv/static/"})
  plug(:match)
  plug(UserAuth)
  plug(UserMessage)
  plug(:dispatch)

  @title "Elixir JWT Auth Demo App"

  forward("/auth", to: User.Controller)

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  # redirect "/" to "/auth"
  get "/" do
    conn
    |> put_resp_header("location", "/auth/register")
    |> send_resp(301, "")
  end

  # protected
  get "/protected" do
    # IO.inspect(conn.assigns[:user], label: "USER ASSIGNS")
    flash_kind = conn.assigns[:flash_kind]
    flash_msg = conn.assigns[:flash_msg]
    # IO.inspect(flash_msg, label: "SUCCESS MSG LOGIN")

    case conn.assigns[:user] do
      nil ->
        conn
        |> put_resp_header("location", "/auth/login")
        |> send_resp(303, "")

      user ->
        conn
        |> send_resp(
          200,
          UserHtml.protected(@title <> " | Protected Page", user, flash_kind, flash_msg)
        )
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
