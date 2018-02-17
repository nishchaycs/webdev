defmodule Tasktracker.AcTracker.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.AcTracker.Task


  schema "tasks" do
    field :description, :string
    field :time_spent, :time
    field :title, :string
    belongs_to :user, Tasktracker.Accccounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :time_spent, :user_id])
    |> validate_required([:title, :description, :time_spent, :user_id])
  end
end
