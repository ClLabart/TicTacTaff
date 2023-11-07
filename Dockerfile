FROM elixir:1.15.6-alpine

# RUN apt-get update && \ apt-get install -y postgresql-client

WORKDIR /app
COPY ./timeManager /app

COPY ./entrypoint.sh /

RUN rm /app/config/dev.local.exs

RUN mix local.hex --force
RUN mix deps.get

RUN mix do compile
RUN source .env

EXPOSE 4000
CMD ["sh", "/entrypoint.sh"]