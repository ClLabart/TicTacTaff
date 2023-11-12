sleep 30

mix ecto.create
mix ecto.migrate

exec mix phx.server