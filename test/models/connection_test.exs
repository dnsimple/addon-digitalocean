defmodule DigitalOceanConnector.ConnectionTest do
  use DigitalOceanConnector.ModelCase

  alias DigitalOceanConnector.Connection

  @valid_attrs %{digitalocean_droplet_id: 42, dnsimple_domain_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Connection.changeset(%Connection{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Connection.changeset(%Connection{}, @invalid_attrs)
    refute changeset.valid?
  end
end
