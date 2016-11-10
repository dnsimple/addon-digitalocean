defmodule DigitalOceanConnector.PageControllerTest do
  use DigitalOceanConnector.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert assert redirected_to(conn) =~ "/dnsimple/authorize"
  end
end
