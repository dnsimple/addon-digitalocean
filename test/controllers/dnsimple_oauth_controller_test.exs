defmodule DigitalOceanConnector.DnsimpleOauthControllerTest do
  use DigitalOceanConnector.ConnCase, async: true

  setup do
    {:ok, dnsimple_client_id: Application.fetch_env!(:digitalocean_connector, :dnsimple_client_id)}
  end

  test "GET /dnsimple/authorize", %{conn: conn, dnsimple_client_id: dnsimple_client_id} do
    conn = get conn, "/dnsimple/authorize"
    state = get_session(conn, :dnsimple_oauth_state)
    assert redirected_to(conn) == "https://dnsimple.com/oauth/authorize?response_type=code&client_id=#{dnsimple_client_id}&state=#{state}"
  end

  test "GET /dnsimple/callback", %{conn: conn} do
    conn = get conn, dnsimple_oauth_path(conn, :new)
    conn = get conn, dnsimple_oauth_path(conn, :create, state: get_session(conn, :dnsimple_oauth_state))
    assert redirected_to(conn) == connection_path(conn, :index)
  end

  test "/dnsimple/callback with mismatched state", %{conn: conn} do
    assert_raise(RuntimeError, fn() ->
      get conn, dnsimple_oauth_path(conn, :create, state: "bad")
    end)
  end
end
