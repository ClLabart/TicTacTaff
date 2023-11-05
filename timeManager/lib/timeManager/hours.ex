defmodule TimeManager.Hours do
  @moduledoc """
  The Hours context.
  """

  import Ecto.Query, warn: false
  require Logger
  require Timex

  alias TimeManager.Repo

  alias TimeManager.Hours.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  def find_user!(id) do
    # current_datetime = DateTime.now("Etc/UTC")

    # IO.puts(current_datetime)

    query =
      from(c in Clock,
        where:
          c.user == ^id and c.time >= ^"2023-11-03T00:00:00Z" and
            c.time <= ^"2023-11-03T23:59:59Z",
        select: c
      )

    Repo.all(query)
  end

  # def get_clock_by_user!(id) do
  #   query = from(c in Clock, where: c.user == ^id)
  #   Repo.all(query)
  # end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}, id) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Ecto.Changeset.put_change(:user, String.to_integer(id))
    |> Repo.insert()
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{data: %Clock{}}

  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end
end
