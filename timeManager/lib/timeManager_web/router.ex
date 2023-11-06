defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TimeManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeManagerWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeManagerWeb do
    pipe_through :api

    resources "/users", UsersController, except: [:new, :edit]

    resources "/workingtimes", WorkingTimeController, except: [:index, :show, :new, :edit]
    get "/workingtimes/:userId", WorkingTimeController, :show_by_user
    get "/workingtimes/:userId/:id" , WorkingTimeController, :show_by_user_id
    post "/workingtimes/:userId", WorkingTimeController, :create_by_user

    resources "/clocks", ClockController, except: [:new, :edit]
    # Récupération des pointages par un utilisateur (id)
    get "/clocks/:id", ClockController, :show
    # Création d'un pointage pour un utilisateur (id)
    post "/clocks/:id", ClockController, :create

    resources "/teams", TeamController, except: [:new, :edit]

    get "/teams/alltimes/:id", TeamController, :alltimes
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timeManager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
