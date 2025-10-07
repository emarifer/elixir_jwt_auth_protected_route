defmodule ElixirJwtAuthProtectedRoute.Web.User.Auth do
  import Plug.Conn

  alias ElixirJwtAuthProtectedRoute.Web.User.JwtConfig, as: Jwt
  alias ElixirJwtAuthProtectedRoute.Web.User.Message

  def init(opts), do: opts

  def call(conn, _opt) do
    conn = fetch_cookies(conn)
    token = conn.req_cookies["jwt"]
    #  |> IO.inspect(label: "TOKEN")

    if token do
      case Jwt.verify_and_validate(token, Jwt.signer()) do
        {:ok, claims} ->
          user = claims["sub"]
          # |> IO.inspect(label: "USER")
          assign(conn, :user, user)

        {:error, reason} ->
          IO.inspect(reason, label: "REASON")
          conn
      end
    else
      case conn.request_path do
        "/protected" ->
          conn
          |> Message.set_flash_msg("warning", "you don't have authorization")

        _ ->
          conn
      end
    end
  end
end
