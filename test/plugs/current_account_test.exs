defmodule DigitalOceanConnector.Plug.CurrentAccountTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias DigitalOceanConnector.Plug.CurrentAccount

  @session Plug.Session.init(
    store: :cookie,
    key: "_key",
    encryption_salt: "encryption-salt",
    signing_salt: "signing-salt"
  )

  setup do
    account = %{
      :dnsimple_access_token => "dnsimple-token",
      :dnsimple_account_id => "1234",
      :digitalocean_access_token => "do-token"
    }

    conn = conn(:get, "/")
    |> Map.put(:secret_key_base, String.duplicate("abcdcefg", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session
    {:ok, conn: conn, account: account}
  end

  test "current_account returns the account if it is in conn.assigns", %{conn: conn, account: account} do
    conn = Plug.Conn.assign(conn, :current_account, account)
    assert CurrentAccount.current_account(conn) == account
  end

  test "current_account returns empty account struct if the account is not in assigns or session", %{conn: conn} do
    assert CurrentAccount.current_account(conn) == %{:digitalocean_access_token => nil, :dnsimple_access_token => nil, :dnsimple_account_id => nil}
  end

  test "redirect if there is no account in the session", %{conn: conn} do
    conn = conn
    |> Phoenix.Controller.fetch_flash
    |> CurrentAccount.call([])

    assert Phoenix.ConnTest.redirected_to(conn) == DigitalOceanConnector.Router.Helpers.dnsimple_oauth_path(conn, :new)
  end
end
