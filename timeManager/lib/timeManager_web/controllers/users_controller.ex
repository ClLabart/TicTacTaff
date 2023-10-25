defmodule TimeManagerWeb.UsersController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Users
  action_fallback(TimeManagerWeb.FallbackController)

  def index(conn, %{"email" => email, "username" => username} =  _params) do
    users = Accounts.list_users()
    filtered_users = Enum.filter(users, fn user -> user.username == username and user.email == email end)
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

  def find_by_email_and_username(conn, %{"email" => email, "username" => username} = _params) do
    # On récupère la liste de tout les utilisateurs
    users = Accounts.list_users()
    # On vérifie que les paramètres email et username ne sont pas null
    if email != nil and username != nil do
    # On filtre la liste des utilisateurs en fonction des paramètres email et username
    filtered_users =
      Enum.filter(users, fn user -> user.username == username and user.email == email end)
    # On retourne la liste des utilisateurs filtrés
    render(conn, :index, users: filtered_users)
    end
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
