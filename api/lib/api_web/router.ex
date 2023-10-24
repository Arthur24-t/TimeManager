defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api
    resources "/users", UserController, exept: [:new, :edit]
    scope "/clocks" do
      get "/:userId", ClockController, :index
      post "/:userId", ClockController, :create
    end
    resources "/workingtimes", WorkingTimeController, exept: [:new, :edit]
  end
end
