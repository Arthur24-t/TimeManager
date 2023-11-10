# web/router.ex
  defmodule ApiWeb.Router do
    alias Hex.Solver.Term
    use ApiWeb, :router

    pipeline :api do
      plug :accepts, ["json"]
    end

    pipeline :authenticated do

      plug :accepts, ["json"]
      plug Api.Auth.CSRFCheck
      plug Guardian.Plug.VerifyHeader, realm: "Bearer", module: Api.Auth.Guardian, error_handler: Api.Auth.GuardianErrorHandler
      plug Guardian.Plug.LoadResource, module: Api.Auth.Guardian,
      error_handler: Api.Auth.GuardianErrorHandler
      plug Api.Auth.FetchCurrentUser
    end

    scope "/", ApiWeb do
      pipe_through :api

      post "/register", AuthController, :register
      post "/login", AuthController, :login
    end


  scope "/api", ApiWeb do
    pipe_through [:authenticated]

    #route user
    resources "/users", UserController
    delete "/users/:user_id", UserController, :delete
    post "/users/:user_id/teams/:team_id", UserController, :add_team_to_user
    delete "/users/:user_id/teams/:team_id", UserController, :remove_team_from_user

    #route clocks
    resources "/clocks/:userID", ClockController, only: [:create]
    get "/clocks/:userID", ClockController, :show

    #route workingtime
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:id", WorkingTimeController, :show
    post "/workingtimes/:userID", WorkingTimeController, :create
    put "/workingtimes/:id", WorkingTimeController, :update
    delete "/workingtimes/:id", WorkingTimeController, :delete

    #route teams
    post "/teams", TeamController, :create
    delete "/teams/:team_id", TeamController, :delete
    put "/teams/:team_id", TeamController, :update
    get "/teams", TeamController, :index
    get "/teams/:team_id", TeamController, :get_users_of_team


    match :options, "/*path", CorsController, :preflight
  end
end
