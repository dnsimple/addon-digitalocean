defmodule DigitalOceanConnector.Account do
  use DigitalOceanConnector.Web, :model

  alias DigitalOceanConnector.Account
  alias DigitalOceanConnector.Repo

  schema "accounts" do
    field :dnsimple_account_id, :string
    field :dnsimple_account_email, :string
    field :dnsimple_access_token, :string

    field :digitalocean_account_id, :string
    field :digitalocean_access_token, :string
    field :digitalocean_access_token_expires_at, Ecto.DateTime
    field :digitalocean_refresh_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast_fields = [
      :dnsimple_account_id, :dnsimple_account_email, :dnsimple_access_token,
      :digitalocean_account_id, :digitalocean_access_token,
      :digitalocean_access_token_expires_at, :digitalocean_refresh_token
    ]
    struct
    |> cast(params, cast_fields)
    |> validate_required([:dnsimple_account_id, :dnsimple_account_email, :dnsimple_access_token])
  end

  def get(id) do
    Repo.get(Account, id)
  end

  def get!(id) do
    Repo.get!(Account, id)
  end

  def create(model, params \\ %{}) do
    model
    |> changeset(params)
    |> Repo.insert
  end

  def create!(model, params \\ %{}) do
    model
    |> changeset(params)
    |> Repo.insert!
  end

  def find_or_create(dnsimple_account_id, params \\ %{}) do
    case Repo.get_by(Account, dnsimple_account_id: dnsimple_account_id) do
      nil -> create(%Account{dnsimple_account_id: dnsimple_account_id}, params)
      account -> {:ok, account}
    end
  end

  def find_or_create!(dnsimple_account_id, params \\ %{}) do
    case Repo.get_by(Account, dnsimple_account_id: dnsimple_account_id) do
      nil -> create!(%Account{dnsimple_account_id: dnsimple_account_id}, params)
      account -> account
    end
  end

  def update(changeset) do
    Repo.update(changeset)
  end

  def update!(changeset) do
    Repo.update!(changeset)
  end
end
