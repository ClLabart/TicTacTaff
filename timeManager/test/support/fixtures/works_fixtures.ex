defmodule TimeManager.WorksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Works` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2023-10-23 07:52:00Z],
        start: ~U[2023-10-23 07:52:00Z]
      })
      |> TimeManager.Works.create_working_time()

    working_time
  end
end
