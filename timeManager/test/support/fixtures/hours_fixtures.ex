defmodule TimeManager.HoursFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Hours` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-10-23 07:51:00Z]
      })
      |> TimeManager.Hours.create_clock()

    clock
  end
end
