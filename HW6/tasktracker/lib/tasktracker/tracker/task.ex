defmodule Tasktracker.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Tracker.Task


  schema "tasks" do
    field :description, :string
    field :done, :boolean, default: false
    field :time_spent, :time
    field :title, :string
    belongs_to :user, Tasktracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :time_spent, :done, :user_id])
    |> validate_required([:title, :description, :time_spent, :done, :user_id])
  end
end
