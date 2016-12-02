defmodule DigitalOceanConnector.PageControllerTest do
  use DigitalOceanConnector.ConnCase, async: true

  @session Plug.Session.init(
    store: :cookie,
    key: "_key",
    encryption_salt: "encryption-salt",
    signing_salt: "signing-salt"
  )

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) =~ "/dnsimple/authorize"
  end

  test "POST /logout", %{conn: conn} do
    conn = conn
    |> Map.put(:secret_key_base, String.duplicate("abcdcefg", 8))
    |> Plug.Session.call(@session)
    |> fetch_session
    |> put_session(:dnsimple_access_token, "123")
    |> post("/logout")

    assert redirected_to(conn) =~ "/bye"
    assert get_session(conn, :dnsimple_access_token) == nil
  end

  test "GET /bye", %{conn: conn} do
    conn = get conn, "/bye"
    assert html_response(conn, 200) =~ "Log back in"
  end
end
