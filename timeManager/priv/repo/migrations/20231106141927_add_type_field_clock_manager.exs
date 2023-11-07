defmodule TimeManager.Repo.Migrations.AddTypeFieldClockManager do
  use Ecto.Migration

  def change do
    alter table(:workingtimes) do
      add :type, :string, default: nil
    end
  end

end
