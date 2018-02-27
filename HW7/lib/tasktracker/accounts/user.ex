defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :manager_bool, :boolean
    belongs_to :manager, Tasktracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :manager_bool, :manager_id])
    |> unique_constraint(:email)
    |> validate_required([:email, :name, :manager_bool])
  end
end
