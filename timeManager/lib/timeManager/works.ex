defmodule TimeManager.Works do
  @moduledoc """
  The Works context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.Users
  alias TimeManager.Works.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Returns the list of workingtimes by user.

  ## Examples

      iex> list_workingtimes_by_user()
      [%WorkingTime{}, ...]
  """
  def list_workingtimes_by_user(id) do
    query = from w in WorkingTime,
      where: w.user == ^id
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a user based on the start time.

  ## Example

      iex> list_workingtimes_by_user_start(1, ~U[2022-01-01 09:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_user_start(id, start) do
    query = from w in WorkingTime,
      where: w.user == ^id and w.start >= ^start
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a user based on the end time.

  ## Example

      iex> list_workingtimes_by_user_end(1, ~U[2022-01-01 17:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_user_end(id, endV) do
    query = from w in WorkingTime,
      where: w.user == ^id and w.end <= ^endV
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a user based on the start and end times.

  ## Example

      iex> list_workingtimes_by_user_start_end(1, ~U[2022-01-01 09:00:00Z], ~U[2022-01-01 17:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_user_start_end(id, start, endV) do
    query = from w in WorkingTime,
      where: w.user == ^id and w.start >= ^start and w.end <= ^endV
    Repo.all(query)
  end

  @doc """
  Returns the list of workingtimes by team.

  ## Examples

      iex> list_workingtimes_by_team()
      [%WorkingTime{}, ...]
  """
  def list_workingtimes_by_team(id) do
    query = from w in WorkingTime,
      join: u in Users,
      on: u.id == w.user,
      where: u.team_id == ^id
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a team based on the start time.

  ## Example

      iex> list_workingtimes_by_team_start(1, ~U[2022-01-01 09:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_team_start(id, start) do
    query = from w in WorkingTime,
      join: u in Users,
      on: u.id == w.user,
      where: u.team_id == ^id and w.start >= ^start
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a team based on the end time.

  ## Example

      iex> list_workingtimes_by_team_end(1, ~U[2022-01-01 17:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_team_end(id, endV) do
    query = from w in WorkingTime,
      join: u in Users,
      on: u.id == w.user,
      where: u.team_id == ^id and w.end <= ^endV
    Repo.all(query)
  end

  @doc """
  Returns a list of working times for a team based on the start and end times.

  ## Example

      iex> list_workingtimes_by_team_start_end(1, ~U[2022-01-01 09:00:00Z], ~U[2022-01-01 17:00:00Z])
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_by_team_start_end(id, start, endV) do
    query = from w in WorkingTime,
      join: u in Users,
      on: u.id == w.user,
      where: u.team_id == ^id and w.start >= ^start and w.end <= ^endV
    Repo.all(query)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def get_working_time_by_user(userId, id) do
    query = from w in WorkingTime,
      where: w.user == ^userId and w.id == ^id
    Repo.one(query)
  end

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a working_time by user.

  ## Examples

      iex> create_working_time_by_user(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time_by_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time_by_user(attrs \\ %{}, id) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Ecto.Changeset.put_change(:user, String.to_integer(id))
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
