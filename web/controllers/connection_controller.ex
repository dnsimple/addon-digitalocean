defmodule DigitalOceanConnector.ConnectionController do
  use DigitalOceanConnector.Web, :controller

  plug DigitalOceanConnector.Plug.CurrentAccount

  alias DigitalOceanConnector.Connection
  alias DigitalOceanConnector.DigitalOcean
  alias DigitalOceanConnector.Dnsimple

  def index(conn, _params) do
    account = conn.assigns[:current_account]
    connections = connection_service.get_connections(account)
    case length(connections) do
      0 -> redirect(conn, to: connection_path(conn, :new))
      _ -> render(conn, "index.html", connections: connections)
    end
  end

  def new(conn, _params) do
    account = conn.assigns[:current_account]
    render(conn, "new.html", changeset: Connection.changeset(%Connection{}),
                              domains: Dnsimple.domains(account),
                              droplets: DigitalOcean.list_droplets(account.digitalocean_access_token))
  end

  def create(conn, %{"connection" => %{"dnsimple_domain_id" => domain_name, "digitalocean_droplet_id" => droplet_id}}) do
    account = conn.assigns[:current_account]

    connection_service.create_connection(domain_name, droplet_id, account)

    conn
    |> put_flash(:info, "Connection created successfully.")
    |> redirect(to: connection_path(conn, :index))
  end

  def show(conn, %{"id" => _id}) do
    redirect(conn, to: connection_path(conn, :index))
  end

  def edit(conn, %{"id" => _id}) do
    redirect(conn, to: connection_path(conn, :index))
  end

  def update(conn, %{"id" => _id, "connection" => _connection_params}) do
    redirect(conn, to: connection_path(conn, :index))
  end

  def delete(conn, %{"id" => id, "records" => records}) do
    account = conn.assigns[:current_account]

    Dnsimple.delete_records(account, id, records)

    conn
    |> put_flash(:info, "Connection deleted successfully.")
    |> redirect(to: connection_path(conn, :index))
  end

  defp connection_service do
    Application.get_env(:digitalocean_connector, :connection_service, DigitalOceanConnector.ConnectionService)
  end
end
