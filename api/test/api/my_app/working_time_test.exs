defmodule Todolist.MyApp.WorkingTimeTest do
  use Todolist.DataCase

  alias Todolist.MyApp.WorkingTime

  describe "working_times" do
    alias Todolist.MyApp.WorkingTime.WorkingTime

    @valid_attrs %{start: ~N[2010-04-17 14:00:00], end: ~N[2010-04-17 14:00:00], user_id: 42}
    @update_attrs %{start: ~N[2011-05-18 15:01:01], end: ~N[2011-05-18 15:01:01], user_id: 43}
    @invalid_attrs %{start: nil, end: nil, user_id: nil}

    def working_time_fixture(attrs \\ %{}) do
      {:ok, working_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkingTime.create_working_time()

      working_time
    end

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert WorkingTime.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert WorkingTime.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      assert {:ok, %WorkingTime{} = working_time} = WorkingTime.create_working_time(@valid_attrs)
      assert working_time.start == ~N[2010-04-17 14:00:00]
      assert working_time.end == ~N[2010-04-17 14:00:00]
      assert working_time.user_id == 42
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{} = working_time} = WorkingTime.update_working_time(working_time, @update_attrs)
      assert working_time.start == ~N[2011-05-18 15:01:01]
      assert working_time.end == ~N[2011-05-18 15:01:01]
      assert working_time.user_id == 43
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_working_time(working_time, @invalid_attrs)
      assert working_time == WorkingTime.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = WorkingTime.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_working_time(working_time)
    end
  end
end
