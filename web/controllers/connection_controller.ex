defmodule DigitalOceanConnector.ConnectionController do
  use DigitalOceanConnector.Web, :controller

  plug DigitalOceanConnector.Plug.CurrentAccount

  alias DigitalOceanConnector.Connection
  alias DigitalOceanConnector.ConnectionService
  alias DigitalOceanConnector.DigitalOcean

  def index(conn, _params) do
    account = conn.assigns[:current_account]
    render(conn, "index.html", changeset: Connection.changeset(%Connection{}),
                      domains: DigitalOceanConnector.Dnsimple.domains(account),
                      droplets: DigitalOceanConnector.DigitalOcean.list_droplets(account.digitalocean_access_token),
                      connections: DigitalOceanConnector.ConnectionService.get_connections(account))
  end

  def new(conn, _params) do
    account = conn.assigns[:current_account]
    render(conn, "new.html", changeset: changeset = Connection.changeset(%Connection{}),
                              domains: DigitalOceanConnector.Dnsimple.domains(account),
                              droplets: DigitalOceanConnector.DigitalOcean.list_droplets(account.digitalocean_access_token))
  end

  def create(conn, %{"connection" => %{"dnsimple_domain_id" => domain_name, "digitalocean_droplet_id" => droplet_id} = connection_params}) do
    changeset = Connection.changeset(%Connection{}, connection_params)
    account = conn.assigns[:current_account]

    ConnectionService.create_connection(domain_name, droplet_id, account)

    conn
    |> put_flash(:info, "Connection created successfully.")
    |> redirect(to: connection_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    connection = Repo.get!(Connection, id)
    render(conn, "show.html", connection: connection)
  end

  def edit(conn, %{"id" => id}) do
    connection = Repo.get!(Connection, id)
    changeset = Connection.changeset(connection)
    account = conn.assigns[:current_account]
    render(conn, "edit.html", connection: connection, changeset: changeset,
                        domains: DigitalOceanConnector.Dnsimple.domains(account),
                        droplets: DigitalOceanConnector.DigitalOcean.list_droplets(account.digitalocean_access_token))
  end

  def update(conn, %{"id" => id, "connection" => connection_params}) do
    connection = Repo.get!(Connection, id)
    changeset = Connection.changeset(connection, connection_params)

    case Repo.update(changeset) do
      {:ok, connection} ->
        conn
        |> put_flash(:info, "Connection updated successfully.")
        |> redirect(to: connection_path(conn, :show, connection))
      {:error, changeset} ->
        account = conn.assigns[:current_account]
        render(conn, "edit.html", connection: connection, changeset: changeset, domains: DigitalOceanConnector.Dnsimple.domains(account),
        droplets: DigitalOceanConnector.DigitalOcean.list_droplets(account.digitalocean_access_token))
    end
  end

  def delete(conn, %{"id" => id, "records" => records} = params) do
    account = conn.assigns[:current_account]

    DigitalOceanConnector.Dnsimple.delete_records(account, id, records)

    conn
    |> put_flash(:info, "Connection deleted successfully.")
    |> redirect(to: connection_path(conn, :index))
  end
end
