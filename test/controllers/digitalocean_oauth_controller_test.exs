defmodule DigitalOceanConnector.DigitalOceanOauthControllerTest do
  use DigitalOceanConnector.ConnCase, async: true

  setup do
    {:ok,
      digitalocean_client_id: Application.fetch_env!(:digitalocean_connector, :digitalocean_client_id),
      digitalocean_callback_url: Application.fetch_env!(:digitalocean_connector, :digitalocean_callback_url)
    }
  end

  test "GET /digitalocean/authorize", %{conn: conn, digitalocean_client_id: client_id, digitalocean_callback_url: callback_url} do
    conn = get conn, "/digitalocean/authorize"
    state = get_session(conn, :digitalocean_oauth_state)
    assert redirected_to(conn) == "https://cloud.digitalocean.com/v1/oauth/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{callback_url}&scope=read write&state=#{state}"
  end

  test "GET /digitalocean/callback", %{conn: conn} do
    # find or create dnsimple account within applyconn = get conn, dnsimple_oauth_path(conn, :new)
    # this could be replaced with setting the session_key `account_id` to a valid Account
    conn = get conn, dnsimple_oauth_path(conn, :new)
    conn = get conn, dnsimple_oauth_path(conn, :create, state: get_session(conn, :dnsimple_oauth_state))

    conn = get conn, digital_ocean_oauth_path(conn, :new)
    conn = get conn, digital_ocean_oauth_path(conn, :create, state: get_session(conn, :digitalocean_oauth_state))
    assert text_response(conn, 200) =~ "Hello "
  end

  test "/digitalocean/callback with mismatched state", %{conn: conn} do
    assert_raise(RuntimeError, fn() ->
      get conn, digital_ocean_oauth_path(conn, :create, state: "bad")
    end)
  end
end
