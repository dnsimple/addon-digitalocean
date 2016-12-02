defmodule DigitalOceanConnector.PageController do
  use DigitalOceanConnector.Web, :controller

  def index(conn, _params) do
    redirect conn, to: dnsimple_oauth_path(conn, :new)
  end

  def logout(conn, _params) do
    conn
    |> clear_session
    |> redirect(to: page_path(conn, :bye))
  end

  def bye(conn, _params) do
    render(conn, "bye.html")
  end
end
