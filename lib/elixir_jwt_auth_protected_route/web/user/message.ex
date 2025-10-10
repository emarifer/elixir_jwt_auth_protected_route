defmodule ElixirJwtAuthProtectedRoute.Web.User.Message do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # flash = fetch_cookies(conn).req_cookies["flash_msg"]
    # See note below
    flash =
      conn
      |> fetch_cookies()
      |> get_cookies()
      |> Access.get("flash_msg")

    if flash do
      {kind, msg} = get_flash_msg(flash)

      conn
      |> delete_resp_cookie("flash_msg")
      |> assign(:flash_kind, kind)
      |> assign(:flash_msg, msg)
    else
      conn
    end
  end

  def set_flash_msg(conn, kind, msg) do
    flash_enc =
      Jason.encode!(%{kind: kind, msg: msg})
      |> Base.encode64(padding: false)

    # `http_only: true` ==> meant only for the server
    conn
    |> put_resp_cookie("flash_msg", flash_enc,
      max_age: 1,
      path: "/",
      http_only: true
    )
  end

  defp get_flash_msg(flash) do
    %{"kind" => kind, "msg" => msg} =
      Base.decode64!(flash, padding: false)
      |> Jason.decode!()

    {kind, msg}
  end
end

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
