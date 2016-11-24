defmodule DigitalOceanConnector.DigitalOcean do

  alias DigitalOceanConnector.DigitalOceanApi

  @oauthbase "https://cloud.digitalocean.com/v1/oauth"
  @apibase "https://api.digitalocean.com/v2"

  def authorize_url(client_id, options) do
    "#{@oauthbase}/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{options[:callback_url]}&scope=read write&state=#{options[:state]}"
  end

  def exchange_authorization_for_token(code, client_id, client_secret, options) do
    url = Enum.join([
      "#{@oauthbase}/token",
      "?grant_type=authorization_code",
      "&code=#{code}",
      "&client_id=#{client_id}",
      "&client_secret=#{client_secret}",
      "&redirect_uri=#{options[:callback_url]}"
    ])
    http_service.post!(url, "", headers)
    |> Map.get(:body)
    |> Poison.decode!
  end

  def list_droplets(access_token) do
    http_service.get!("#{@apibase}/droplets", headers([{"Authorization", "Bearer #{access_token}"}]))
    |> Map.get(:body)
    |> Poison.decode!
    |> Map.get("droplets")
  end

  def get_droplet(access_token, id) do
    http_service.get!("#{@apibase}/droplets/#{id}", headers([{"Authorization", "Bearer #{access_token}"}]))
    |> Map.get(:body)
    |> Poison.decode!
    |> Map.get("droplet")
  end

  # returns [{"v4", "159.203.139.124"}, {"v6", nil}]
  def get_ips_from_droplet(droplet) do
    droplet["networks"]
    |> Enum.map(fn ({x, list}) ->
      public_interface = Enum.find(list, &(&1["type"] == "public"))
      {x, public_interface["ip_address"]}
    end)
  end

  def headers(additionals \\ []) do
    additionals ++ [{"Content-Type", "application/json"}]
  end

  defp http_service do
     Application.get_env(:digitalocean_connector, :digitalocean_oauth_service, HTTPoison)
  end

end
