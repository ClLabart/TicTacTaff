defmodule TimeManagerWeb.UsersController do
  import JOSE.JWT
  import JOSE.JWK
  import JOSE.JWS
  use TimeManagerWeb, :controller

  alias TimeManager.Repo
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

  defp hmac_sha256(key, message) do
    key_binary = <<key::binary>>
    message_binary = <<message::binary>>
    :crypto.hash(:sha256, key_binary <> message_binary)
  end

  def login(conn, %{"email" => email, "password" => password}) do
    require Logger
    Logger.info("Debut du debug")
    user = Accounts.get_users_by_email(email)

    secret_key = "z9%P25y6Jr22ZeZ):D97m$Hz]!a5[K4x5ik(43z?-TJe*wTK@E"
    # key_binary = <<secret_key::binary>>
    hash_password = String.downcase(Base.encode16(hmac_sha256(secret_key, password)))

    case :crypto.hash_equals(hash_password, user.password) do
      :ok ->
        render(conn, :show, users: user)
      :false ->
        render(conn, :error)
    end

    # Exemple de génération d'un JWT avec Joken
    claims = %{
      # ID de l'utilisateur
      "usrUniqueId" => 1,
      # Team ID de l'utilisateur
      "teamUniqueId" => 1,
      # 30 minutes
      "exp" => DateTime.to_unix(DateTime.add(DateTime.utc_now(), 1800, :second))
    }

    header = %{"alg" => "HS256", "typ" => "JWT"}

    encoded_header = :base64.encode(Jason.encode!(header))
    encoded_claims = :base64.encode(Jason.encode!(claims))

    data_to_sign = "#{encoded_header}.#{encoded_claims}"
    signature = hmac_sha256(secret_key, data_to_sign) |> :base64.encode()

    token = "#{encoded_header}.#{encoded_claims}.#{signature}"

    render(conn, :token, users: user, token: token)
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
