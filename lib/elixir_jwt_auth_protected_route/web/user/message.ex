defmodule ElixirJwtAuthProtectedRoute.Web.User.Message do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opt) do
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

  defp get_flash_msg(conn) do
    flash = fetch_cookies(conn).req_cookies["flash_msg"]

    %{"kind" => kind, "msg" => msg} =
      Base.decode64!(flash, padding: false)
      |> Jason.decode!()

    {kind, msg}
  end
end
