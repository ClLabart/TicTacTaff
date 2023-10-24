defmodule TimeManager.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end
end
