defmodule DigitalOceanConnector.Router do
  use DigitalOceanConnector.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DigitalOceanConnector do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/logout", PageController, :logout
    get "/bye", PageController, :bye

    get "/dnsimple/authorize", DnsimpleOauthController, :new
    get "/dnsimple/callback", DnsimpleOauthController, :create

    get "/digitalocean/authorize", DigitalOceanOauthController, :new
    get "/digitalocean/callback", DigitalOceanOauthController, :create

    resources "/connections", ConnectionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DigitalOceanConnector do
  #   pipe_through :api
  # end
end
