defmodule Tasktracker.Tracker do
  @moduledoc """
  The Tracker context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.Tracker.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
    |> Repo.preload(:user)
    |> Repo.preload(:timeblocks)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do 
    Repo.get!(Task, id)
    |> Repo.preload(:user)
    |> Repo.preload(:timeblocks)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  alias Tasktracker.Tracker.Timetrack

  @doc """
  Returns the list of timetracks.

  ## Examples

      iex> list_timetracks()
      [%Timetrack{}, ...]

  """
  def list_timetracks do
    Repo.all(Timetrack)
  end

  def list_task_timeblocks(task_id) do
    Repo.all(from t in Timetrack, where: t.task_id == ^task_id)
  end

  @doc """
  Gets a single timetrack.

  Raises `Ecto.NoResultsError` if the Timetrack does not exist.

  ## Examples

      iex> get_timetrack!(123)
      %Timetrack{}

      iex> get_timetrack!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timetrack!(id), do: Repo.get!(Timetrack, id)

  @doc """
  Creates a timetrack.

  ## Examples

      iex> create_timetrack(%{field: value})
      {:ok, %Timetrack{}}

      iex> create_timetrack(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timetrack(attrs \\ %{}) do
    %Timetrack{}
    |> Timetrack.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timetrack.

  ## Examples

      iex> update_timetrack(timetrack, %{field: new_value})
      {:ok, %Timetrack{}}

      iex> update_timetrack(timetrack, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timetrack(%Timetrack{} = timetrack, attrs) do
    timetrack
    |> Timetrack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timetrack.

  ## Examples

      iex> delete_timetrack(timetrack)
      {:ok, %Timetrack{}}

      iex> delete_timetrack(timetrack)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timetrack(%Timetrack{} = timetrack) do
    Repo.delete(timetrack)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timetrack changes.

  ## Examples

      iex> change_timetrack(timetrack)
      %Ecto.Changeset{source: %Timetrack{}}

  """
  def change_timetrack(%Timetrack{} = timetrack) do
    Timetrack.changeset(timetrack, %{})
  end
end
