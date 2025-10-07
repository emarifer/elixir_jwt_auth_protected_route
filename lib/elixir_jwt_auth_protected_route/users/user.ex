defmodule ElixirJwtAuthProtectedRoute.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :hashed_password, :string

    timestamps(type: :utc_datetime)
  end

  @min_chars 3
  @max_chars 25

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:username, :hashed_password])
    |> validate_required([:username, :hashed_password])
    |> validate_length(:username, min: @min_chars, max: @max_chars)
    |> unique_constraint(:username)
    |> put_hashed_password()
  end

  # Encryption of the password if the previous validations are passed,
  # otherwise it does not hash the password.
  defp put_hashed_password(
         %Ecto.Changeset{valid?: true, changes: %{hashed_password: hashed_password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(hashed_password))
  end

  defp put_hashed_password(changeset), do: changeset
end

# COMMANDS:
# mix ecto.create
# mix ecto.gen.migration create_users_table
# mix ecto.migrate

# REFERENCES
# Making a field unique in ecto:
# https://stackoverflow.com/questions/32460920/making-a-field-unique-in-ecto
# MIGRATIONS:
# https://hexdocs.pm/phoenix/ecto.html#mix-tasks
# https://elixirforum.com/t/mix-ecto-gen-migration-creates-empty-migration/22249/2

# INSERT FROM IEX:
#
# User.changeset(%User{}, %{username: "enrique", hashed_password: "353gsa"}) |> Repo.insert ==>
# 17:42:13.470 [debug] [mfa=Ecto.Adapters.SQL.log/5 ] QUERY OK source="users" db=52.0ms idle=1347.3ms
# INSERT INTO "users" ("username","hashed_password","inserted_at","updated_at","id") VALUES (?1,?2,?3,?4,?5) ["enrique", "353gsa", ~U[2025-10-04 15:42:13Z], ~U[2025-10-04 15:42:13Z], "8cf55d6d-8360-4aa0-948d-d083744c235f"]
# ↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
# {:ok,
#  %ElixirJwtAuthProtectedRoute.User.User{
#    __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
#    id: "8cf55d6d-8360-4aa0-948d-d083744c235f",
#    username: "enrique",
#    hashed_password: "353gsa",
#    inserted_at: ~U[2025-10-04 15:42:13Z],
#    updated_at: ~U[2025-10-04 15:42:13Z]
#  }}
#
# VERIFYING THE UNIQUENESS OF THE "username" FIELD:
#
# User.changeset(%User{}, %{username: "enrique", hashed_password: "466fbx"}) |> Repo.insert
# 17:43:39.619 [debug] [mfa=Ecto.Adapters.SQL.log/5 ] QUERY ERROR source="users" db=0.3ms idle=1548.1ms
# INSERT INTO "users" ("username","hashed_password","inserted_at","updated_at","id") VALUES (?1,?2,?3,?4,?5) ["enrique", "466fbx", ~U[2025-10-04 15:43:39Z], ~U[2025-10-04 15:43:39Z], "8da332bd-d47e-40c8-aa68-1b942d22ccbe"]
# ↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
# {:error,
#  #Ecto.Changeset<
#    action: :insert,
#    changes: %{username: "enrique", hashed_password: "466fbx"},
#    errors: [
#      username: {"has already been taken",
#       [constraint: :unique, constraint_name: "users_username_index"]}
#    ],
#    data: #ElixirJwtAuthProtectedRoute.User.User<>,
#    valid?: false,
#    ...
#  >}
