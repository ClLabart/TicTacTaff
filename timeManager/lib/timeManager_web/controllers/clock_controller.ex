defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Hours
  alias TimeManager.Hours.Clock
  import Logger

  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, _params) do
    clocks = Hours.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"id" => id, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Hours.create_clock(clock_params, id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, params) do
    id = Map.get(params, "id")
    clocks = Hours.find_user!(id)
    render(conn, :index, clocks: clocks)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Hours.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Hours.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Hours.get_clock!(id)

    with {:ok, %Clock{}} <- Hours.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
