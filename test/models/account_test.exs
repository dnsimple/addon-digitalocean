defmodule DigitalOceanConnector.AccountTest do
  use DigitalOceanConnector.ModelCase

  alias DigitalOceanConnector.Account

  @valid_attrs %{dnsimple_access_token: "some content", dnsimple_account_email: "some content", dnsimple_account_id: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
