defmodule DigitalOceanConnector.Connection do
  use DigitalOceanConnector.Web, :model

  schema "connections" do
    belongs_to :account, DigitalOceanConnector.Account
    field :dnsimple_domain_id, :string
    field :digitalocean_droplet_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dnsimple_domain_id, :digitalocean_droplet_id])
    |> validate_required([:dnsimple_domain_id, :digitalocean_droplet_id])
  end
end
