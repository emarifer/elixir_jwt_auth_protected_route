defmodule ElixirJwtAuthProtectedRoute.Users do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query
  alias ElixirJwtAuthProtectedRoute.{Repo, Users.User}

  def get_user_by_id(id), do: Repo.get(User, id)

  def get_user_by_name(name) do
    User
    |> where([u], u.username == ^name)
    |> Repo.all()
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
