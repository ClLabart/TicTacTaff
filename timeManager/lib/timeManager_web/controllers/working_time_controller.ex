defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Works
  alias TimeManager.Works.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Works.list_workingtimes()
    render(conn, :index, workingtimes: workingtimes)
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
end
