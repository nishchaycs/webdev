defmodule Tasktracker.Repo.Migrations.AddManagerBool do
  use Ecto.Migration

  def change do
  	alter table(:users) do
  		add :manager_bool, :boolean, default: false, null: false
  	end
  end
end
