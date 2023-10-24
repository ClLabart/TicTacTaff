defmodule TimeManager.WorksTest do
  use TimeManager.DataCase

  alias TimeManager.Works

  describe "workingtimes" do
    alias TimeManager.Works.WorkingTime

    import TimeManager.WorksFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Works.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Works.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~U[2023-10-23 07:52:00Z], end: ~U[2023-10-23 07:52:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Works.create_working_time(valid_attrs)
      assert working_time.start == ~U[2023-10-23 07:52:00Z]
      assert working_time.end == ~U[2023-10-23 07:52:00Z]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Works.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~U[2023-10-24 07:52:00Z], end: ~U[2023-10-24 07:52:00Z]}

      assert {:ok, %WorkingTime{} = working_time} = Works.update_working_time(working_time, update_attrs)
      assert working_time.start == ~U[2023-10-24 07:52:00Z]
      assert working_time.end == ~U[2023-10-24 07:52:00Z]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Works.update_working_time(working_time, @invalid_attrs)
      assert working_time == Works.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Works.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Works.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Works.change_working_time(working_time)
    end
  end
end
