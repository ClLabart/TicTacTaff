defmodule TimeManager.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  import Logger
  alias TimeManager.Repo
  alias TimeManager.Accounts
  alias TimeManager.Accounts.Users
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :firstname, :string
    field :lastname, :string
    belongs_to :team, TimeManager.Teams.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:username, :email, :password, :role, :firstname, :lastname])
    # |> foreign_key_constraint(:team_id, name: :users_team_id_fkey)
    |> cast_assoc(:team)
    |> validate_required([:username, :email, :password, :role, :firstname, :lastname])
    |> validate_format(:email, ~r/^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{1,4}$/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Logger.info("Debut du debug")
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  # def verify_user(%{"password" => password} = params) do
  #   case Users.get_by(params) do
  #     nil ->
  #       {:error, "User not found"}
  #     user ->
  #       Bcrypt.verify_pass(password, user.password)
  #   end
  # end

  # defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
  #   change(changeset, Argon2.hash_pwd_salt(password))
  # end

  # defp put_password_hash(changeset), do: changeset

  # def verify_user(%{"password" => password} = params) do
  #   case Users.get_by(params) do
  #     nil ->
  #       {:error, "User not found"}
  #     user ->
  #       Argon2.verify_pass(password, user.password_hash)
  #   end
  # end


  # defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
  #     %{password: password}} = changeset) do
  #   change(changeset, Argon2.add_hash(password))
  # end

  # defp put_pass_hash(changeset), do: changeset

  # def authenticate_user(email, password) do
  #   user = Repo.get_by(YourApp.User, email: email)

  #   case user do
  #     nil ->
  #       {:error, "User not found"}
  #     _ ->
  #       if Comeonin.checkpw(password, user.password_hash) do
  #         {:ok, user}
  #       else
  #         {:error, "Invalid password"}
  #       end
  #   end
  # end

  # defp put_password_hash(%Ecto.Changeset{valid?: true, changes:
  #   %{password: password}} = changeset) do
  #   change(changeset, Argon2.hash_pwd_salt(password))
  # end

  # defp put_password_hash(changeset), do: changeset

  # def verify_user(%{"password" => password} = params) do
  #   params
  #   |> Users.get_by()
  #   |> Argon2.verify_pass(password)
  # end

  # defp put_password_hash(changeset) do
  #   # case get_field(changeset, :password) do
  #   #   nil -> changeset
  #   #   password ->
  #   #     # hashed_password = Comeonin.Bcrypt.hashpwsalt(password, log_rounds: 12)
  #   #     # change(changeset, password: hashed_password)
  #   # end
  # end

  # def authenticate_user(email, password) do
  #   user = Accounts.get_users_by_email(email)
  #   # user = Repo.get_by(TimeManager.Users, email: email)

  #   # case user do
  #   #   nil ->
  #   #     {:error, "User not found"}
  #   #   _ ->
  #   #     if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
  #   #       {:ok, user}
  #   #     else
  #   #       {:error, "Invalid password"}
  #   #     end
  #   # end
  # end

  # defp put_password_hash(changeset) when is_map(changeset.changes) and changeset.valid? do
  #   # require Logger
  #   secret_key = "z9%P25y6Jr22ZeZ):D97m$Hz]!a5[K4x5ik(43z?-TJe*wTK@E"
  #   password = changeset.changes[:password]
  #   hash_password = hmac_sha256(secret_key, password)
  #   # Logger.info("Debut du debug")
  #   # Logger.info(hash_password)
  #   change(changeset, password: hash_password)
  # end

  # defp put_password_hash(changeset), do: changeset

  # defp hmac_sha256(key, message) do
  #   key_binary = <<key::binary>>
  #   message_binary = <<message::binary>>
  #   String.downcase(Base.encode16(:crypto.hash(:sha256, key_binary <> message_binary)))
  # end
end
