defmodule ElixirJwtAuthProtectedRoute.Web.User.HtmlFlash do
  require EEx

  @template_dir File.cwd!() <> "/lib/elixir_jwt_auth_protected_route/web/templates/"

  EEx.function_from_file(:def, :flash, @template_dir <> "components/flash.html.eex", [
    :kind,
    :msg
  ])
end
