defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Clock

  action_fallback ApiWeb.FallbackController

  def show(conn, %{"userID" => user_id}) when is_binary(user_id) do
    clocks = Accounts.list_user_clocks(user_id)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => user_id, "clock" => clock_params}) when is_binary(user_id) do
    case Accounts.create_user_clock(user_id, clock_params) do
      {:ok, %Clock{} = clock} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
        |> render("show.json", clock: clock)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
