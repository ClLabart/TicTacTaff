defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Works
  alias TimeManager.Works.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Works.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
  end

  def create_by_user(conn, %{"userId" => id, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Works.create_working_time_by_user(working_time_params, id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show_by_user(conn, params) do
    id = Map.get(params, "userId")

    filtered_workingtimes =
      case {Map.get(params, "start"), Map.get(params, "end")} do
        {nil, nil} ->
          Works.list_workingtimes_by_user(id)

        {start, nil} ->
          Works.list_workingtimes_by_user_start(id, start)

        {nil, endV} ->
          Works.list_workingtimes_by_user_end(id, endV)

        {start, endV} ->
          Works.list_workingtimes_by_user_start_end(id, start, endV)

        _ ->
          Works.list_workingtimes_by_user(id)
      end

    render(conn, :index, workingtimes: filtered_workingtimes)
  end

  def show_by_user_id(conn, %{"userId" => userId, "id" => id}) do
    working_time = Works.get_working_time_by_user(userId, id)
    render(conn, :show, working_time: working_time)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Works.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Works.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Works.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Works.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Works.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Works.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def alltimes(conn, params) do
    # Avoir les working times en fonction d'une équipe
    # Avec en params possible start et end
    id = Map.get(params, "id")

    filtered_workingtimes =
      case {Map.get(params, "start"), Map.get(params, "end")} do
        {nil, nil} ->
          Works.list_workingtimes_by_team(id)

        {start, nil} ->
          Works.list_workingtimes_by_team_start(id, start)

        {nil, endV} ->
          Works.list_workingtimes_by_team_end(id, endV)

        {start, endV} ->
          Works.list_workingtimes_by_team_start_end(id, start, endV)

        _ ->
          Works.list_workingtimes_by_team(id)
      end

    render(conn, :index, workingtimes: filtered_workingtimes)
  end
end
