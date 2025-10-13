defmodule ElixirJwtAuthProtectedRoute.Web.User.Auth do
  import Plug.Conn

  alias ElixirJwtAuthProtectedRoute.Web.User.JwtConfig, as: Jwt
  alias ElixirJwtAuthProtectedRoute.Web.User.Message

  def init(opts), do: opts

  def call(conn, _opts) do
    # conn = fetch_cookies(conn)
    # token = conn.req_cookies["jwt"]
    # See note below

    token =
      conn
      |> fetch_cookies()
      |> get_cookies()
      |> Access.get("jwt")

    # |> IO.inspect(label: "TOKEN")

    if token do
      case Jwt.verify_and_validate(token, Jwt.signer()) do
        {:ok, claims} ->
          user = claims["sub"]
          # |> IO.inspect(label: "USER")

          assign(conn, :user, user)

        {:error, token_error} when is_atom(token_error) ->
          conn
          |> delete_resp_cookie("jwt")
          |> unauthorized_message(Atom.to_string(token_error) |> String.replace("_", " "))

        {:error, token_error} when is_list(token_error) ->
          if Keyword.has_key?(token_error, :message) do
            conn
            |> delete_resp_cookie("jwt")
            |> unauthorized_message(Keyword.fetch!(token_error, :message))
          else
            # catch-all
            conn
            |> delete_resp_cookie("jwt")
            |> unauthorized_message("token validation error")
          end
      end
    else
      unauthorized_message(conn, "you don't have authorization")
    end
  end

  defp unauthorized_message(conn, msg) do
    case conn.request_path do
      "/protected" ->
        conn
        |> Message.set_flash_msg("warning", msg)
        |> put_resp_header("location", "/auth/login")
        |> send_resp(303, "")
        |> halt()

      _ ->
        conn
    end
  end
end

# REFERENCES:
# Stop the pipeline ==>
# https://hexdocs.pm/plug/Plug.Conn.html#halt/1

# NOTE:
# Some fields of the struct `%Plug.Conn{}` must first be fetched
# using functions prefixed with `fetch_` [https://elixirforum.com/t/setting-up-test-for-a-plug/4781/2  *** https://hexdocs.pm/plug/Plug.Conn.html#module-fetchable-fields].
# Since v1.17.0 (2025-03-14) getting the `cookies`, `req_cookies`
# or `resp_cookies` field directly from the `%Plug.Conn{}` struct is deprecated.
# https://elixirforum.com/t/setting-up-test-for-a-plug/4781/2
# https://hexdocs.pm/plug/Plug.Conn.html#get_cookies/1
# https://github.com/elixir-plug/plug/blob/v1.18.1/lib/plug/conn.ex#L1587
# https://hexdocs.pm/plug/Plug.Conn.html#module-deprecated-fields
# https://hexdocs.pm/plug/changelog.html#v1-17-0-2025-03-14
