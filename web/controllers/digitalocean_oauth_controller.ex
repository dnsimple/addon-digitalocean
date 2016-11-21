defmodule DigitalOceanConnector.DigitalOceanOauthController do
  use DigitalOceanConnector.Web, :controller

  alias DigitalOceanConnector.Account
  import DigitalOceanConnector.DigitalOcean, only: [seconds_in_to_ecto_date: 1]

  def new(conn, _params) do
    client_id = Application.fetch_env!(:digitalocean_connector, :digitalocean_client_id)
    callback_url = Application.fetch_env!(:digitalocean_connector, :digitalocean_callback_url)
    state = :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)
    conn = put_session(conn, :digitalocean_oauth_state, state)
    oauth_url = DigitalOceanConnector.DigitalOcean.authorize_url(client_id, state: state, callback_url: callback_url)
    redirect(conn, external: oauth_url)
  end

  def create(conn, params) do
    if params["state"] != get_session(conn, :digitalocean_oauth_state) do
      raise "State does not match"
    end

    client_id = Application.fetch_env!(:digitalocean_connector, :digitalocean_client_id)
    callback_url = Application.fetch_env!(:digitalocean_connector, :digitalocean_callback_url)
    client_secret = Application.fetch_env!(:digitalocean_connector, :digitalocean_client_secret)

    response = DigitalOceanConnector.DigitalOcean.exchange_authorization_for_token(params["code"], client_id, client_secret, callback_url: callback_url)

    # persist in DB
    get_session(conn, :account_id)
    |> Account.get!
    |> Account.changeset(%{
      "digitalocean_account_id" => response["info"]["uuid"],
      "digitalocean_access_token" => response["access_token"],
      "digitalocean_access_token_expires_at" => seconds_in_to_ecto_date(response["expires_in"]),
      "digitalocean_refresh_token" => response["refresh_token"]
    })
    |> Account.update!

    redirect conn, to: connection_path(conn, :index)
  end
end
