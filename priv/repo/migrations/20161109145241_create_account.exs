defmodule DigitalOceanConnector.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :dnsimple_account_id, :string
      add :dnsimple_account_email, :string
      add :dnsimple_access_token, :string

      timestamps()
    end

  end
end
