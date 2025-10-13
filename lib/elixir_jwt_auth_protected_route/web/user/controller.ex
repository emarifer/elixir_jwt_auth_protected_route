defmodule ElixirJwtAuthProtectedRoute.Web.User.Controller do
  require Logger
  use Plug.Router

  alias ElixirJwtAuthProtectedRoute.Web.User.Html, as: UserHtml
  alias ElixirJwtAuthProtectedRoute.Web.User.JwtConfig, as: Jwt
  alias ElixirJwtAuthProtectedRoute.Web.User.Message
  alias ElixirJwtAuthProtectedRoute.Users, as: UsersContext
  alias ElixirJwtAuthProtectedRoute.Users.User

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:dispatch)

  @title "Elixir JWT Auth Demo App"

  # register
  get "/register" do
    flash_kind = conn.assigns[:flash_kind]
    flash_msg = conn.assigns[:flash_msg]
    # IO.inspect(flash_msg, label: "ERROR MSG REGISTER")

    UserHtml.register(@title <> " | Register", flash_kind, flash_msg)
    |> then(&send_resp(conn, 200, &1))
  end

  # login
  get "/login" do
    flash_kind = conn.assigns[:flash_kind]
    flash_msg = conn.assigns[:flash_msg]
    # IO.inspect(flash_msg, label: "ERROR MSG LOGIN")

    UserHtml.login(@title <> " | Login", conn.assigns[:user], flash_kind, flash_msg)
    |> then(&send_resp(conn, 200, &1))
  end

  # create user
  post "/register" do
    bparams = conn.body_params

    Logger.debug("create - #{inspect(bparams)}")

    with {:ok, _} <- UsersContext.register_user(bparams) do
      conn
      |> put_resp_header("location", "/auth/login")
      |> Message.set_flash_msg("success", "You have successfully signup")
      |> send_resp(303, "")
    else
      {:error, changeset_err} ->
        # %Ecto.Changeset{errors: [username: {flash_msg, _}]} = changeset_err

        %{username: [msg]} =
          Ecto.Changeset.traverse_errors(changeset_err, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        # ↑↑ See: https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2

        flash_msg = "username: #{msg}"

        conn
        |> put_resp_header("location", "/auth/register")
        |> Message.set_flash_msg("warning", flash_msg)
        |> send_resp(303, "")
    end
  end

  post "/signin" do
    bparams = conn.body_params

    Logger.debug("signin - #{inspect(bparams)}")

    %{"username" => name, "hashed_password" => pass} = bparams

    case UsersContext.get_user_by_name(name) do
      [] ->
        conn
        |> Message.set_flash_msg("warning", "the user does not exist")
        |> put_resp_header("location", "/auth/login")
        |> send_resp(303, "")

      [%User{username: username, hashed_password: hashed_password}] ->
        # Logger.debug("ID - #{id}")

        case Argon2.verify_pass(pass, hashed_password) do
          true ->
            jwt = Jwt.generate_jwt(username)
            # |> IO.inspect(label: "JWT")

            conn
            |> put_resp_header("location", "/protected")
            |> put_resp_cookie("jwt", jwt, max_age: 90, path: "/", http_only: true)
            |> Message.set_flash_msg("success", "you have successfully logged in")
            |> send_resp(303, "")

          false ->
            conn
            |> put_resp_header("location", "/auth/login")
            |> Message.set_flash_msg("warning", "incorrect password")
            |> send_resp(303, "")
        end
    end
  end

  get "/logout" do
    UserHtml.login(@title <> " | Login", nil, "success", "you have successfully logged out")
    |> then(&send_resp(delete_resp_cookie(conn, "jwt"), 200, &1))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
