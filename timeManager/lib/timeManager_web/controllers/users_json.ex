defmodule TimeManagerWeb.UsersJSON do
  alias TimeManager.Accounts.Users

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(users <- users, do: data(users))}
  end

  @doc """
  Renders a single users.
  """
  def show(%{users: users}) do
    %{data: data(users)}
  end

  defp data(%Users{} = users) do
    %{
      id: users.id,
      username: users.username,
      email: users.email,
      role: users.role,
      firstname: users.firstname,
      lastname: users.lastname,
      # team: if is_nil(users.team) do
      #       %{
      #         id: nil,
      #         name: nil
      #       }
      #     else
      #       %{
      #         id: users.team.id,
      #         name: users.team.name
      #       }
      #     end
      team: if is_nil(users.team) do
            nil
          else
            users.team
          end
    }
  end
end
