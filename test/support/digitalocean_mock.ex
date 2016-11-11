defmodule DigitalOceanConnector.DigitalOcean.OauthMock do
  def post(url, body, headers) do
    response_body = """
    {
      "access_token": "547cac21118ae7",
      "token_type": "bearer",
      "expires_in": 2592000,
      "refresh_token": "00a3aae641658d",
      "scope": "read write",
      "info": {
        "name": "Sammy the Shark",
        "email":"sammy@digitalocean.com",
        "uuid":"e028b1b918853eca7fba208a9d7e9d29a6e93c57"
      }
    }
    """
    {:ok, %HTTPoison.Response{body: response_body}}
  end
end
