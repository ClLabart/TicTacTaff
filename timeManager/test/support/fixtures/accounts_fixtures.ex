defmodule TimeManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Accounts` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "x@x.x",
        username: "some username"
        firstname: "john",
        lastname: "doe",
        role: "employee",
        password: "some password",
      })
      |> TimeManager.Accounts.create_users()

    users
  end
end
