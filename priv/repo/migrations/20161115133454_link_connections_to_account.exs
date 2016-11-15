defmodule DigitalOceanConnector.Repo.Migrations.LinkConnectionsToAccount do
  use Ecto.Migration

  def change do
    alter table(:connections) do
      add :account_id, references(:accounts)
    end
  end
end
