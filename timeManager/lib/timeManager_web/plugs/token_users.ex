# defmodule TimeManagerWeb.Plugs.AuthenticateUser do
#   import Plug.Conn
#   import Logger

#   def init(_), do: %{}

#   def call(conn, _) do
#     token = get_req_header(conn, "authorization")

#     Logger.info("début debug")

#     if token != nil do
#       Logger.info("token")
#       token =
#         hd(token)
#         |> String.trim()
#         |> String.replace_prefix("Bearer ", "")
#       Logger.info(token)
#       Logger.info("gardian")
#       Logger.info("Token: #{inspect(token)}")
#       case Guardian.decode_and_verify(token, %{"typ" => "access"}) do
#         {:ok, claims} ->
#           Logger.info("claims")
#           Logger.info(claims)
#           Logger.info("fin claims")
#           Logger.info(Map.get(claims, "sub"))

#           user = Accounts.get_users_by_id(Map.get(claims, "sub"))
#           if user == nil do
#             conn
#             |> send_resp(:unauthorized, "user not found")
#             |> halt()
#           else
#             Logger.info("user got")
#             Logger.info(user)
#             assign(conn, :current_user, user)
#           end
#         {:error, %ArgumentError{message: error_message}} ->
#           Logger.error("errorx")
#           conn
#           |> send_resp(:internal_server_error, to_string(error_message))
#           |> halt()
#         {:error, :token_expired} ->
#           Logger.error("errorxy")
#           conn
#           |> send_resp(:unauthorized, "Token expired")
#           |> halt()
#         {:error, error} ->
#           Logger.error("errorxz")
#           conn
#           |> send_resp(:unauthorized, error)
#           |> halt()
#       end
#     else
#       conn
#       |> send_resp(:unauthorized, "Authorization header is missing or invalid")
#       |> halt()
#     end
#   end
# end
