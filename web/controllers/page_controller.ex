defmodule DigitalOceanConnector.PageController do
  use DigitalOceanConnector.Web, :controller

  def index(conn, _params) do
    redirect conn, to: dnsimple_oauth_path(conn, :new)
  end
end
