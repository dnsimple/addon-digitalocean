defmodule DigitalOceanConnector.ConnectionControllerTest do
  use DigitalOceanConnector.ConnCase

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
    DigitalOceanConnector.ConnectionServiceMock.stub_connections [connection_data]

    conn = get conn, connection_path(conn, :index)
    assert html_response(conn, 200) =~ "Existing Connections"
  end

  test "redirects to new connection form when no connection present", %{conn: conn} do
    conn = get conn, connection_path(conn, :index)
    assert redirected_to(conn) == connection_path(conn, :new)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, connection_path(conn, :new)
    assert html_response(conn, 200) =~ "New Connection"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, connection_path(conn, :create), @valid_attrs
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

  defp connection_data do
    {%Dnsimple.Domain{account_id: 12437, auto_renew: false,
   created_at: "2016-11-07T15:45:39.578Z", expires_on: "2017-11-07", id: 264946,
   name: "tests-in.space", private_whois: false, registrant_id: 13468,
   state: "registered", token: "3VrodC9E5DKFKVgOZp4TGjvQjzTFBTSl",
   updated_at: "2016-11-07T15:45:50.224Z"},
  %{"backup_ids" => [], "created_at" => "2016-11-10T16:02:18Z", "disk" => 20,
    "features" => ["virtio"], "id" => 31777909,
    "image" => %{"created_at" => "2016-06-20T05:50:53Z",
      "distribution" => "Ubuntu", "id" => 17999979, "min_disk_size" => 20,
      "name" => "Drupal 8.1.3 on 14.04", "public" => true,
      "regions" => ["nyc1", "sfo1", "nyc2", "ams2", "sgp1", "lon1", "nyc3",
       "ams3", "fra1", "tor1", "sfo2", "blr1"], "size_gigabytes" => 0.6,
      "slug" => "drupal", "type" => "snapshot"}, "kernel" => nil,
    "locked" => false, "memory" => 512, "name" => "drupal-512mb-nyc3-01",
    "networks" => %{"v4" => [%{"gateway" => "159.203.128.1",
         "ip_address" => "159.203.139.124", "netmask" => "255.255.240.0",
         "type" => "public"}], "v6" => []}, "next_backup_window" => nil,
    "region" => %{"available" => true,
      "features" => ["private_networking", "backups", "ipv6", "metadata"],
      "name" => "New York 3",
      "sizes" => ["512mb", "1gb", "2gb", "4gb", "8gb", "16gb", "m-16gb", "32gb",
       "m-32gb", "48gb", "m-64gb", "64gb", "m-128gb", "m-224gb"],
      "slug" => "nyc3"},
    "size" => %{"available" => true, "disk" => 20, "memory" => 512,
      "price_hourly" => 0.00744, "price_monthly" => 5.0,
      "regions" => ["ams1", "ams2", "ams3", "blr1", "fra1", "lon1", "nyc1",
       "nyc2", "nyc3", "sfo1", "sfo2", "sgp1", "tor1"], "slug" => "512mb",
      "transfer" => 1.0, "vcpus" => 1}, "size_slug" => "512mb",
    "snapshot_ids" => [], "status" => "active", "tags" => [], "vcpus" => 1,
    "volume_ids" => []},
  [%Dnsimple.ZoneRecord{content: "tests-in.space",
    created_at: "2016-12-05T11:01:17.197Z", id: 6871552, name: "www",
    parent_id: nil, priority: nil, regions: ["global"], system_record: false,
    ttl: 3600, type: "CNAME", updated_at: "2016-12-05T11:01:17.197Z",
    zone_id: "tests-in.space"},
   %Dnsimple.ZoneRecord{content: "159.203.139.124",
    created_at: "2016-12-05T11:01:16.944Z", id: 6871551, name: "",
    parent_id: nil, priority: nil, regions: ["global"], system_record: false,
    ttl: 3600, type: "A", updated_at: "2016-12-05T11:01:16.944Z",
    zone_id: "tests-in.space"}]}
  end
end
