defmodule TimeManager.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  import Logger
  alias TimeManager.Repo
  alias TimeManager.Accounts
  alias TimeManager.Accounts.Users
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :firstname, :string
    field :lastname, :string
    belongs_to :team, TimeManager.Teams.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :password, :role, :firstname, :lastname])
    # |> foreign_key_constraint(:team_id, name: :users_team_id_fkey)
    |> cast_assoc(:team)
    |> validate_required([:username, :email, :password, :role, :firstname, :lastname])
    |> validate_format(:email, ~r/^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{1,4}$/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Logger.info("Debut du debug")
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
