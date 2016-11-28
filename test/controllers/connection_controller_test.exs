defmodule DigitalOceanConnector.ConnectionControllerTest do
  use DigitalOceanConnector.ConnCase

  alias DigitalOceanConnector.Connection

  @valid_attrs %{digitalocean_droplet_id: 42, dnsimple_domain_id: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = assign(conn, :current_account, %{
      :dnsimple_access_token => "anytoken",
      :dnsimple_account_id => "1234",
      :digitalocean_access_token => "some other token"
    })
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, connection_path(conn, :index)
    assert html_response(conn, 200) =~ "Existing Connections"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, connection_path(conn, :new)
    assert html_response(conn, 200) =~ "New connection"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, connection_path(conn, :create), connection: @valid_attrs
    assert redirected_to(conn) == connection_path(conn, :index)
  end

  test "show redirects to index", %{conn: conn} do
    conn = get conn, connection_path(conn, :show, 1)
    assert redirected_to(conn) == connection_path(conn, :index)
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = delete conn, connection_path(conn, :delete, "example.com", records: [123,234,345])
    assert redirected_to(conn) == connection_path(conn, :index)
  end
end
