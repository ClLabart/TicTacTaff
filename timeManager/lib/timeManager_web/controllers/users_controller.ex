defmodule TimeManagerWeb.UsersController do
  import JOSE.JWT
  import JOSE.JWK
  import JOSE.JWS
  import Guardian.Plug
  use TimeManagerWeb, :controller

  import Logger
  alias TimeManager.Repo
  alias TimeManager.Accounts
  alias TimeManager.Accounts.Users
  alias TimeManager.Guardian
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

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_users_by_email(email) do
      nil ->
        conn
        |> put_status(404)
        |> render(:error, error: "User not found")

      user ->
        user = Repo.preload(user, :team)

        case Bcrypt.verify_pass(password, user.password) do
          true ->
            {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{}, token_type: "access")

            conn
            |> put_status(200)
            |> render(:token, users: user, token: jwt)
          false ->
            conn
            |> put_status(401)
            |> render(:error, error: "Wrong password")
        end
    end
  end

  def test(conn, _params) do
    Logger.info("debug")
    token = get_req_header(conn, "authorization")

    if token != nil do
      token = hd(token) |> String.trim() |> String.replace_prefix("Bearer ", "")

      case Guardian.decode_and_verify(token, %{"typ" => "access"}) do
        {:ok, claims} ->
          Logger.info(claims)
          user = Accounts.get_users!(Map.get(claims, "sub"))
          render(conn, :show, users: user)
        {:error, :token_expired} ->
          Logger.info("Token expired")
      end
    else
      Logger.error("Authorization header is missing or invalid")
    end
  end

  def create(conn, %{"users" => users_params}) do
    with {:ok, %Users{} = users} <- Accounts.create_users(users_params) do
      users = Repo.preload(users, :team)

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
    users = Repo.preload(users, :team)

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

  def change_team(conn, %{"id" => id, "teamId" => teamId}) do
    users = Accounts.get_users!(id)
    # users = Repo.preload(users, :team)
    with {:ok, %Users{} = users} <- Accounts.change_team(users, teamId) do
      users = Repo.preload(users, :team)

      conn
      |> put_resp_header("location", ~p"/api/users/#{users}")
      # |> Repo.preload(users, :team)
      |> render(:show, users: users)
    end
  end
end
