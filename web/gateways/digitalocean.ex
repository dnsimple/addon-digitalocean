defmodule DigitalOceanConnector.DigitalOcean do

  alias DigitalOceanConnector.DigitalOceanApi

  @oauthbase "https://cloud.digitalocean.com/v1/oauth"

  def authorize_url(client_id, options) do
    @oauthbase <> "/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{options[:callback_url]}&scope=read write&state=#{options[:state]}"
  end

  def exchange_authorization_for_token(code, client_id, client_secret, options) do
    url = Enum.join([
      @oauthbase <> "/token",
      "?grant_type=authorization_code",
      "&code=#{code}",
      "&client_id=#{client_id}",
      "&client_secret=#{client_secret}",
      "&redirect_uri=#{options[:callback_url]}"
    ])
    {:ok, response} = http_service.post(url, "", [{"Content-Type", "application/json"}])
    response.body
    |> Poison.decode!
  end

  defp http_service do
     Application.get_env(:digitalocean_connector, :digitalocean_oauth_service, HTTPoison)
  end

end
