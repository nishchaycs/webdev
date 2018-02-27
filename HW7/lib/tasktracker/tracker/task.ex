defmodule Tasktracker.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Tracker.Task
  alias Tasktracker.Tracker.Timetrack


  schema "tasks" do
    field :description, :string
    field :done, :boolean, default: false
    field :title, :string
    belongs_to :user, Tasktracker.Accounts.User
    has_many :time_blocks, Timetrack, foreign_key: :task_id
    has_many :timeblocks, through: [:time_blocks, :task] 

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :done, :user_id])
    |> validate_required([:title, :description, :done, :user_id])
  end
end
