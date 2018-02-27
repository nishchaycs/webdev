defmodule Tasktracker.Repo.Migrations.AddManager do
  use Ecto.Migration

  def change do
  	alter table(:users) do
  		add :manager_id, references(:users, on_delete: :nothing)
  	end
  end
end
