defmodule ElixirJwtAuthProtectedRoute.Web.User.Auth do
  import Plug.Conn

  alias ElixirJwtAuthProtectedRoute.Web.User.JwtConfig, as: Jwt

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
      conn
    end
  end
end
