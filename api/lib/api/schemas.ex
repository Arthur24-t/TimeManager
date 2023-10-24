defmodule Api.Schemas do

  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Schemas.User
  alias Api.Schemas.Clock
  alias Api.Schemas.WorkingTime

  def list_users do
    Repo.all(User)
  end

  def list_users_by_email_username(email, username) do
    query = from(u in User,
    where: u.email == ^email and u.username == ^username
    )
    Repo.all(query)
  end

  def list_clocks do
    Repo.all(Clock)
  end

  def list_working_times do
    Repo.all(WorkingTime)
  end

  def get_user!(id), do: Repo.get!(User, id)
  def get_clock!(id), do: Repo.get!(Clock, id)
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
