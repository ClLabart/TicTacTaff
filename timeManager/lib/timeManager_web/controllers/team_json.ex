defmodule TimeManagerWeb.TeamJSON do
  alias TimeManager.Teams.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      users: case team.users do
        nil -> nil
        users ->
          Enum.map(users, fn user ->
            %{
              id: user.id,
              username: user.username,
              email: user.email,
              role: user.role,
              firstname: user.firstname,
              lastname: user.lastname
            }
          end)
      end
    }
  end
end
