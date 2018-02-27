defmodule Tasktracker.Tracker.Timetrack do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Tracker.Timetrack


  schema "timetracks" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    belongs_to :task, Tasktracker.Tracker.Task

    timestamps()
  end

  @doc false
  def changeset(%Timetrack{} = timetrack, attrs) do
    timetrack
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> validate_required([:start_time, :end_time, :task_id])
  end
end
