defmodule ElixirJwtAuthProtectedRoute.Web.User.Message do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if fetch_cookies(conn).req_cookies["flash_msg"] do
      {kind, msg} = get_flash_msg(conn)

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

  defp get_flash_msg(conn) do
    flash = fetch_cookies(conn).req_cookies["flash_msg"]

    %{"kind" => kind, "msg" => msg} =
      Base.decode64!(flash, padding: false)
      |> Jason.decode!()

    {kind, msg}
  end
end
