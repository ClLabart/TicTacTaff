defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.Users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Users{}, ...]

  """
  def list_users do
    Repo.all(Users) |> Repo.preload(:team)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id) do
    Repo.get!(Users, id)
    |> Repo.preload(:team)
  end

  @doc """
    get a users by it's id.

  ## Examples

      iex> get_users_by_id(123)
      %users{}

      iex> get_users_by_id(456)
      nil
    """
  def get_users_by_id(id) do
    query = from u in Users,
      where: u.id == ^id,
      order_by: [desc: u.inserted_at],
      limit: 1
    Repo.one(query)
    |> Repo.preload(:team)
  end

  @doc """
  Get a single user Users.any(),

  Returns `nil` if the Users does not exist.

  ## Examples

      iex> get_users_by_email(test@mail.com)
      %users{}

      iex> get_users_by_email(no_account@mail.com)
      nil
  """
  def get_users_by_email(email) do
    query = from u in Users,
      where: u.email == ^email,
      order_by: [desc: u.inserted_at],
      limit: 1
    Repo.one(query)
    |> Repo.preload(:team)
    # Users
    # |> Where(email: ^email)
    # |> Repo.one()
  end

    @doc """
  Get a single user, by email and password

  Returns `nil` if the Users does not exist.

  ## Examples

      iex> get_users_by_email_and_password(test@mail.com, hash)
      %users{}

      iex> get_users_by_email_and_password(no_account@mail.com, hash)
      nil
  """
  def get_users_by_email_and_password(email, hash) do
    query = from u in Users,
      where: u.email == ^email and u.password == ^hash
    Repo.one(query)
    |> Repo.preload(:team)
    # Users
    # |> Where(email: ^email)
    # |> Where(password: ^hash)
    # |> Repo.one()
  end

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_users(%Users{} = users, attrs \\ %{}) do
    Users.changeset(users, attrs) |> Repo.preload(:team)
  end

  @doc """
  Updates a users's team.

  ## Examples

      iex> change_team(users, %{field: new_value})
      {:ok, %Users{}}

      iex> change_team(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def change_team(%Users{} = users, teamId) do
    users
    |> Users.changeset(%{})
    |> Ecto.Changeset.put_change(:team_id, String.to_integer(teamId))
    |> Repo.update()
  end

  @doc """
  Remove a users's team.

  ## Examples

      iex> remove_team(users, %{field: new_value})
      {:ok, %Users{}}

      iex> remove_team(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def remove_team(%Users{} = users) do
    users
    |> Users.changeset(%{})
    |> Ecto.Changeset.put_change(:team_id, nil)
    |> Repo.update()
  end
end
