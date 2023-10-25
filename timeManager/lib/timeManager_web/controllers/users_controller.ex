defmodule TimeManagerWeb.UsersController do
  use TimeManagerWeb, :controller
  import Logger

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Users
  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, params) do
    users = Accounts.list_users()

    filtered_users =
      case {Map.get(params, "username"), Map.get(params, "email")} do
        {nil, nil} ->
          users

        {username, nil} ->
          Enum.filter(users, fn user -> user.username == username end)

        {nil, email} ->
          Enum.filter(users, fn user -> user.email == email end)

        {username, email} ->
          Enum.filter(users, fn user -> user.username == username && user.email == email end)

        _ ->
          users
      end

    render(conn, :index, users: filtered_users)
  end

  def create(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- Accounts.create_users(users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{users}")
      |> render(:show, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    users = Accounts.get_users!(id)
    render(conn, :show, users: users)
  end

  def update(conn, %{"id" => id, "users" => users_params}) do
    users = Accounts.get_users!(id)

    with {:ok, %Users{} = users} <- Accounts.update_users(users, users_params) do
      render(conn, :show, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    users = Accounts.get_users!(id)

    with {:ok, %Users{}} <- Accounts.delete_users(users) do
      send_resp(conn, :no_content, "")
    end
  end
end
