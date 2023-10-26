defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.WorkingTime

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"userID" => user_id, "start" => start_date, "end" => end_date}) when is_binary(user_id) do
    working_times = Accounts.find_working_times_by_user_and_date_range(user_id, start_date, end_date)
    render(conn, "index.json", working_times: working_times)
  end

  def show(conn, %{"userID" => user_id, "id" => id}) when is_binary(user_id) do
    with %WorkingTime{} = working_time <- Accounts.get_working_time(user_id, id) do
      render(conn, "show.json", working_time: working_time)
    else
      nil ->
        conn
        |> send_resp(:not_found, "Working Time not found")
    end
  end

  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    case Accounts.create_working_time(Map.merge(%{"user" => user_id}, working_time_params)) do
      {:ok, %WorkingTime{} = working_time} ->
        conn
        |> put_status(:created)
        |> render("show.json", working_time: working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)

      _ ->
        conn
        |> send_resp(:internal_server_error, "Internal Server Error")
    end
  end



  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    case Accounts.get_working_time!(id) do
      %WorkingTime{} = working_time ->
        case Accounts.update_working_time(working_time, working_time_params) do
          {:ok, %WorkingTime{} = updated_working_time} ->
            render(conn, "show.json", working_time: updated_working_time)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
          _ ->
            conn
            |> send_resp(:internal_server_error, "Internal Server Error")
        end
      nil ->
        conn
        |> send_resp(:not_found, "Working Time not found")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Accounts.get_working_time!(id) do
      %WorkingTime{} = working_time ->
        case Accounts.delete_working_time(working_time) do
          {:ok, %WorkingTime{}} ->
            send_resp(conn, :no_content, "")
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", error: reason)
        end
      nil ->
        conn
        |> send_resp(:not_found, "Working Time not found")
    end
  end
end
