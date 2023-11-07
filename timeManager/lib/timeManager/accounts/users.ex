defmodule TimeManager.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

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
    # |> cast_assoc(:team)
    |> validate_required([:username, :email, :password, :role, :firstname, :lastname])
    |> validate_format(:email, ~r/^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{1,4}$/)
    |> unique_constraint(:email)
    # |> foreign_key_constraint(:team_id, name: :user_team_fkey)
    # |> put_password_hash()
  end

  # defp put_password_hash(%Ecto.changeset{valid?: true, changes: %{hash_password: hash_password}} = changeset) do
  #   change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password))
  # end

  # defp put_password_hash(changeset), do: changeset
end
