# web/router.ex

defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    resources "/users", UserController
    resources "/clocks/:userID", ClockController, only: [:create]
    get "/clocks/:userID", ClockController, :show
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    post "/workingtimes/:userID", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :update
    delete "/workingtimes/:id", WorkingTimeController, :delete

    # Enables LiveDashboard only for development
    if Mix.env() in [:dev, :test] do
      import Phoenix.LiveDashboard.Router

      scope "/" do
        pipe_through [:fetch_session, :protect_from_forgery]
        live_dashboard "/dashboard", metrics: ApiWeb.Telemetry
      end
    end
  end
end
