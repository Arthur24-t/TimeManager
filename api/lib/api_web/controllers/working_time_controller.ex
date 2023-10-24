defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Schemas
  alias Api.Schemas.WorkingTime

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    working_times = Schemas.list_working_times()
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Schemas.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Schemas.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Schemas.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Schemas.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Schemas.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Schemas.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
