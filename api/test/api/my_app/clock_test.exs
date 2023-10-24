defmodule Todolist.MyApp.ClockTest do
  use Todolist.DataCase

  alias Todolist.MyApp.Clock

  describe "clocks" do
    alias Todolist.MyApp.Clock.Clock

    @valid_attrs %{status: true, time: "2010-04-17T14:00:00Z", user_id: 42}
    @update_attrs %{status: false, time: "2011-05-18T15:01:01Z", user_id: 43}
    @invalid_attrs %{status: nil, time: nil, user_id: nil}

    def clock_fixture(attrs \\ %{}) do
      {:ok, clock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clock.create_clock()

      clock
    end

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Clock.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Clock.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      assert {:ok, %Clock{} = clock} = Clock.create_clock(@valid_attrs)
      assert clock.status == true
      assert clock.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert clock.user_id == 42
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clock.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{} = clock} = Clock.update_clock(clock, @update_attrs)
      assert clock.status == false
      assert clock.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert clock.user_id == 43
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Clock.update_clock(clock, @invalid_attrs)
      assert clock == Clock.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Clock.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Clock.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Clock.change_clock(clock)
    end
  end
end
