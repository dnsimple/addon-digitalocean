defmodule DigitalOceanConnector.Plug.CurrentAccount do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    case current_account(conn) do
      %{ :dnsimple_access_token => nil } ->
        conn
        |> Phoenix.Controller.redirect(to: DigitalOceanConnector.Router.Helpers.dnsimple_oauth_path(conn, :new))
        |> halt
      %{ :digitalocean_access_token => nil } ->
        conn
        |> Phoenix.Controller.redirect(to: DigitalOceanConnector.Router.Helpers.digital_ocean_oauth_path(conn, :new))
        |> halt
      account -> assign(conn, :current_account, account)
    end
  end

  def current_account(conn) do
    case conn.assigns[:current_account] do
      nil -> build_account(conn)
      account -> account
    end
  end

  def build_account(conn) do
    %{
      :dnsimple_access_token => get_session(conn, :dnsimple_access_token),
      :digitalocean_access_token => get_session(conn, :digitalocean_access_token)
    }
  end
end
