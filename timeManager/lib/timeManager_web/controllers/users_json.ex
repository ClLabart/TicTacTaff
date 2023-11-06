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
      team: if is_nil(users.team) do
            %{
              team_id: nil,
              team_name: nil
            }
          else
            %{
              team_id: users.team.id,
              team_name: users.team.name
            }
          end
    }
  end
end
