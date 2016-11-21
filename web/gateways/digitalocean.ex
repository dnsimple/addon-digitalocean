defmodule DigitalOceanConnector.DigitalOcean do

  alias DigitalOceanConnector.Account
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

  def refresh_access_token(account) do
    case access_token_expired?(account) do
      true -> do_refresh_access_token(account)
      false -> account
    end
  end

  defp access_token_expired?(account) do
    case account.digitalocean_access_token_expires_at do
      nil -> false
      expires_at -> Ecto.DateTime.compare(Ecto.DateTime.utc, expires_at) == :gt
    end
  end

  defp do_refresh_access_token(account) do
    url = @oauthbase <> "/token?grant_type=refresh_token&refresh_token=#{account.digitalocean_refresh_token}"
    {:ok, response} = http_service.post(url, "", [{"Content-Type", "application/json"}])
    %{ "access_token" => access_token,
       "refresh_token" => refresh_token,
       "expires_in" => expires_in } = Poison.decode!(response.body)
    Account.changeset(account, %{
      "digitalocean_access_token" => access_token,
      "digitalocean_access_token_expires_at" => seconds_in_to_ecto_date(expires_in),
      "digitalocean_refresh_token" => refresh_token
    })
    |> Account.update!
  end

  def seconds_in_to_ecto_date(expires_in) do
    # Is there a better way to handle calculating when the access
    # token expires?
    unix_now_utc = DateTime.to_unix(DateTime.utc_now())
    epoch = {{1970, 1, 1}, {0, 0, 0}}
    expires_at = unix_now_utc + expires_in
    |> Kernel.+(:calendar.datetime_to_gregorian_seconds(epoch))
    |> :calendar.gregorian_seconds_to_datetime
    |> Ecto.DateTime.from_erl
  end

  defp http_service do
     Application.get_env(:digitalocean_connector, :digitalocean_oauth_service, HTTPoison)
  end

end
