defmodule DigitalOceanConnector.PageController do
  use DigitalOceanConnector.Web, :controller

  def index(conn, _params) do
    redirect conn, to: "/dnsimple/authorize"
  end
end
