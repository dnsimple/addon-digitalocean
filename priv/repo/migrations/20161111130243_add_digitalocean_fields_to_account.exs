defmodule DigitalOceanConnector.Repo.Migrations.AddDigitaloceanFieldsToAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :digitalocean_account_id, :string
      add :digitalocean_access_token, :string
      add :digitalocean_access_token_expires_at, :datetime
      add :digitalocean_refresh_token, :string
    end
  end
end
