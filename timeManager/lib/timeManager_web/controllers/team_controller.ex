defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Repo
  alias TimeManager.Teams
  alias TimeManager.Teams.Team

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      team = Repo.preload(team, :users)
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  # def alltimes(conn, params) do
  #   id = Map.get(params, "id")

  #   team = Teams.get_team!(id)

  #   filtered_workingtimes =
  #     case {Map.get(params, "start"), Map.get(params, "end")} do
  #       {nil, nil} ->
  #         Works.list_workingtimes_by_user(id)

  #       {start, nil} ->
  #         Works.list_workingtimes_by_user_start(id, start)

  #       {nil, endV} ->
  #         Works.list_workingtimes_by_user_end(id, endV)

  #       {start, endV} ->
  #         Works.list_workingtimes_by_user_start_end(id, start, endV)

  #       _ ->
  #         Works.list_workingtimes_by_user(id)
  #     end

  #   render(conn, :index, workingtimes: filtered_workingtimes)
  #   render(conn, :index, teams: filtered_teams)
  # end
end
