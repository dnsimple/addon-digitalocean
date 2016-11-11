defmodule DigitalOceanConnector.Account do
  use DigitalOceanConnector.Web, :model

  alias DigitalOceanConnector.Account
  alias DigitalOceanConnector.Repo

  schema "accounts" do
    field :dnsimple_account_id, :string
    field :dnsimple_account_email, :string
    field :dnsimple_access_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dnsimple_account_id, :dnsimple_account_email, :dnsimple_access_token])
    |> validate_required([:dnsimple_account_id, :dnsimple_account_email, :dnsimple_access_token])
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
end
