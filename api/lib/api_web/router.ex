# web/router.ex
  defmodule ApiWeb.Router do
    use ApiWeb, :router

    pipeline :api do
      plug :accepts, ["json"]
    end

    pipeline :authenticated do
      plug Guardian.Plug.Pipeline,
        module: Api.Auth.Guardian,
        error_handler: Api.Auth.GuardianErrorHandler
      plug Guardian.Plug.EnsureAuthenticated
    end

    scope "/", ApiWeb do
      pipe_through :api

      post "/register", AuthController, :register
      post "/login", AuthController, :login
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
    match :options, "/*path", CorsController, :preflight
  end
end
