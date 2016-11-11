defmodule DigitalOceanConnector.DigitalOceanApi do

  use HTTPoison.Base

  def process_url(url) do
    "https://cloud.digitalocean.com/v1" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

end
