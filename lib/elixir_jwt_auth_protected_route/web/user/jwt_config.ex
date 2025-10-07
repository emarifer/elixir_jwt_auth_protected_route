defmodule ElixirJwtAuthProtectedRoute.Web.User.JwtConfig do
  @moduledoc """
  This module defines the configuration for JWT token generation and validation.

  ## Why is this needed?
  Joken requires a configuration module that implements `Joken.Config` to:
  - Define standard claims (like expiration).
  - Ensure consistent signing and verification logic.
  - Keep token-related logic separate from business logic.

  This modular approach keeps JWT logic centralized while allowing your signin.ex plug to focus purely on authentication.
  """

  # implements all Joken functions <- Can use JwtConfig like Joken.<function>
  use Joken.Config

  @impl true
  def token_config do
    # Expiration in seconds
    # default_claims(default_exp: 60 * 60 * 2)
    default_claims(default_exp: 60)
  end

  def signer do
    Joken.Signer.create(
      "HS256",
      Application.get_env(:elixir_jwt_auth_protected_route, :jwt_secret)
    )
  end

  def generate_jwt(username) do
    # No need to manually set "exp" (handled in token_config callback)
    # iat (issued at) <- for debugging token creation times
    claims = %{"sub" => username, "iat" => Joken.current_time()}
    {:ok, token, _} = generate_and_sign(claims, signer())

    token
  end
end
