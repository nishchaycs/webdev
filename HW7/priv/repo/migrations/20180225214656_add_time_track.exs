defmodule Tasktracker.Repo.Migrations.AddTimeTrack do
  use Ecto.Migration

  def change do
  	alter table(:tasks) do
  		remove :time_spent
  	end
  end
end
