defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.WorkingTime

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => user_id, "start" => start_date, "end" => end_date}) when is_binary(user_id) do
    working_times = Accounts.find_working_times_by_user_and_date_range(user_id, start_date, end_date)
    render(conn, "index.json", working_times: working_times)
  end

  def create(conn, %{"userID" => userID, "working_time" => workingtime_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Accounts.create_working_time(Map.merge(%{"user" => userID}, workingtime_params)) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end


  def show(conn, %{"userID" => user_id, "id" => id}) when is_binary(user_id) do
    working_time = Accounts.get_working_time(user_id,id)
    render(conn, "show.json", working_time: Enum.at(working_time, 0))
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Accounts.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Accounts.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
