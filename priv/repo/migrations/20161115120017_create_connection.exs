defmodule DigitalOceanConnector.Repo.Migrations.CreateConnection do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :dnsimple_domain_id, :string
      add :digitalocean_droplet_id, :integer

      timestamps()
    end

  end
end
