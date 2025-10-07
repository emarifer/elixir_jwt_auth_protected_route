defmodule ElixirJwtAuthProtectedRoute.Web.User.Html do
  require EEx
  require Logger

  @template_dir File.cwd!() <> "/lib/elixir_jwt_auth_protected_route/web/templates/"

  EEx.function_from_file(:def, :root_html, @template_dir <> "root.html.eex", [
    :inner_content,
    :title
  ])

  EEx.function_from_file(:def, :register_html, @template_dir <> "components/register.html.eex", [
    :kind,
    :msg
  ])

  EEx.function_from_file(:def, :login_html, @template_dir <> "components/login.html.eex", [
    :user,
    :kind,
    :msg
  ])

  EEx.function_from_file(
    :def,
    :protected_html,
    @template_dir <> "components/protected.html.eex",
    [:user, :kind, :msg]
  )

  def register(title, kind, msg) do
    register_html(kind, msg)
    |> root_html(title)
  end

  def login(title, user, kind, msg) do
    login_html(user, kind, msg)
    |> root_html(title)
  end

  def protected(title, user, kind, msg) do
    protected_html(user, kind, msg)
    |> root_html(title)
  end
end
