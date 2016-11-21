defmodule DigitalOceanConnector.DnsimpleOauthController do
  use DigitalOceanConnector.Web, :controller

  def new(conn, _params) do
    client    = %Dnsimple.Client{}
    client_id = Application.fetch_env!(:digitalocean_connector, :dnsimple_client_id)
    state = :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)
    conn = put_session(conn, :dnsimple_oauth_state, state)
    oauth_url = DigitalOceanConnector.Dnsimple.authorize_url(client, client_id, state: state)
    redirect(conn, external: oauth_url)
  end

  def create(conn, params) do

    if params["state"] != get_session(conn, :dnsimple_oauth_state) do
      raise "State does not match"
    end

    client = %Dnsimple.Client{}
    attributes = %{
      client_id: Application.fetch_env!(:digitalocean_connector, :dnsimple_client_id),
      client_secret: Application.fetch_env!(:digitalocean_connector, :dnsimple_client_secret),
      code: params["code"],
      state: params["state"]
    }
    case DigitalOceanConnector.Dnsimple.exchange_authorization_for_token(client, attributes) do
      {:ok, response} ->
        access_token = response.data.access_token
        conn
        put_session(conn, :dnsimple_access_token, access_token)
        |> redirect(to: connection_path(conn, :index))
      {:error, error} ->
        IO.inspect(error)
        raise "OAuth authentication failed: #{inspect error}"
    end

  end
end
