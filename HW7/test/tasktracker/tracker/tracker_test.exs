defmodule Tasktracker.TrackerTest do
  use Tasktracker.DataCase

  alias Tasktracker.Tracker

  describe "tasks" do
    alias Tasktracker.Tracker.Task

    @valid_attrs %{description: "some description", done: true, time_spent: ~T[14:00:00.000000], title: "some title"}
    @update_attrs %{description: "some updated description", done: false, time_spent: ~T[15:01:01.000000], title: "some updated title"}
    @invalid_attrs %{description: nil, done: nil, time_spent: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracker.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tracker.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tracker.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tracker.create_task(@valid_attrs)
      assert task.description == "some description"
      assert task.done == true
      assert task.time_spent == ~T[14:00:00.000000]
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Tracker.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.description == "some updated description"
      assert task.done == false
      assert task.time_spent == ~T[15:01:01.000000]
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_task(task, @invalid_attrs)
      assert task == Tracker.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tracker.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tracker.change_task(task)
    end
  end

  describe "timetracks" do
    alias Tasktracker.Tracker.Timetrack

    @valid_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end_time: nil, start_time: nil}

    def timetrack_fixture(attrs \\ %{}) do
      {:ok, timetrack} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracker.create_timetrack()

      timetrack
    end

    test "list_timetracks/0 returns all timetracks" do
      timetrack = timetrack_fixture()
      assert Tracker.list_timetracks() == [timetrack]
    end

    test "get_timetrack!/1 returns the timetrack with given id" do
      timetrack = timetrack_fixture()
      assert Tracker.get_timetrack!(timetrack.id) == timetrack
    end

    test "create_timetrack/1 with valid data creates a timetrack" do
      assert {:ok, %Timetrack{} = timetrack} = Tracker.create_timetrack(@valid_attrs)
      assert timetrack.end_time == ~N[2010-04-17 14:00:00.000000]
      assert timetrack.start_time == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_timetrack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_timetrack(@invalid_attrs)
    end

    test "update_timetrack/2 with valid data updates the timetrack" do
      timetrack = timetrack_fixture()
      assert {:ok, timetrack} = Tracker.update_timetrack(timetrack, @update_attrs)
      assert %Timetrack{} = timetrack
      assert timetrack.end_time == ~N[2011-05-18 15:01:01.000000]
      assert timetrack.start_time == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_timetrack/2 with invalid data returns error changeset" do
      timetrack = timetrack_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_timetrack(timetrack, @invalid_attrs)
      assert timetrack == Tracker.get_timetrack!(timetrack.id)
    end

    test "delete_timetrack/1 deletes the timetrack" do
      timetrack = timetrack_fixture()
      assert {:ok, %Timetrack{}} = Tracker.delete_timetrack(timetrack)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_timetrack!(timetrack.id) end
    end

    test "change_timetrack/1 returns a timetrack changeset" do
      timetrack = timetrack_fixture()
      assert %Ecto.Changeset{} = Tracker.change_timetrack(timetrack)
    end
  end
end
