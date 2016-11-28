defmodule DigitalOceanConnector.ConnectionServiceTest do
  use ExUnit.Case, async: true

  alias DigitalOceanConnector.ConnectionService


  # networks = [{"v4", "159.203.139.124"}, {"v6", nil}]

  test "#get_zone_records returns CNAME record" do
    networks = [{"v4", "159.203.139.124"}]
    records = ConnectionService.get_zone_records networks, "example.com"

    assert record(records, "CNAME").content == "example.com"
  end

  test "#get_zone_records returns A record for a given IPv4 network" do
    networks = [{"v4", "159.203.139.124"}]
    records = ConnectionService.get_zone_records networks, "example.com"

    assert record(records, "A").content == "159.203.139.124"
  end

  test "#get_zone_records returns AAAA record for a given IPv4 network" do
    networks = [{"v6", "2001:0db8:85a3:0000:0000:8a2e:0370:7334"}]
    records = ConnectionService.get_zone_records networks, "example.com"

    assert record(records, "AAAA").content == "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
  end

  test "#get_zone_records returns all required records to connect a domain to a droplet" do
    networks = [{"v4", "159.203.139.124"}, {"v6", "2001:0db8:85a3:0000:0000:8a2e:0370:7334"}]
    records = ConnectionService.get_zone_records networks, "example.com"

    assert length(records) === 3
    assert Enum.map(records, &(&1.type)) == ["A", "AAAA", "CNAME"]
  end

  test "#find_connections find connections from ip used in droplet" do
    domains = [
      {%Dnsimple.Domain{name: "tests-in.space"}, [
        %Dnsimple.ZoneRecord{content: "138.68.76.233", name: "", type: "A", zone_id: "tests-in.space"},
        %Dnsimple.ZoneRecord{content: "2A03:B0C0:0003:00D0:0000:0000:224F:5001", name: "", type: "AAAA", zone_id: "tests-in.space"},
        %Dnsimple.ZoneRecord{content: "tests-in.space", name: "www", type: "CNAME", zone_id: "tests-in.space"}
     ]}
   ]

   droplets = [
     %{"id" => 31777909, "name" => "drupal-512mb-nyc3-01", "size_slug" => "512mb", "status" => "active",
       "networks" => %{
         "v4" => [%{"gateway" => "159.203.128.1", "ip_address" => "159.203.139.124", "netmask" => "255.255.240.0", "type" => "public"}],
         "v6" => []
       }},
     %{"id" => 32682437, "name" => "wordpress-512mb-fra1-01", "size_slug" => "512mb", "status" => "active",
       "networks" => %{
         "v4" => [%{"gateway" => "138.68.64.1", "ip_address" => "138.68.76.233", "netmask" => "255.255.240.0", "type" => "public"}],
         "v6" => [%{"gateway" => "2A03:B0C0:0003:00D0:0000:0000:0000:0001", "ip_address" => "2A03:B0C0:0003:00D0:0000:0000:224F:5001", "netmask" => 64, "type" => "public"}]
       }
     }
   ]

    connections = ConnectionService.find_connections(domains, droplets)

    assert connections == [
      {%Dnsimple.Domain{name: "tests-in.space"}, %{"id" => 32682437, "name" => "wordpress-512mb-fra1-01", "size_slug" => "512mb", "status" => "active",
        "networks" => %{
          "v4" => [%{"gateway" => "138.68.64.1", "ip_address" => "138.68.76.233", "netmask" => "255.255.240.0", "type" => "public"}],
          "v6" => [%{"gateway" => "2A03:B0C0:0003:00D0:0000:0000:0000:0001", "ip_address" => "2A03:B0C0:0003:00D0:0000:0000:224F:5001", "netmask" => 64, "type" => "public"}]
        }}, [
          %Dnsimple.ZoneRecord{content: "tests-in.space", created_at: nil, id: nil, name: "www", parent_id: nil, priority: nil, regions: nil, system_record: nil, ttl: nil, type: "CNAME", updated_at: nil, zone_id: "tests-in.space"},
          %Dnsimple.ZoneRecord{content: "138.68.76.233", created_at: nil, id: nil, name: "", parent_id: nil, priority: nil, regions: nil, system_record: nil, ttl: nil, type: "A", updated_at: nil, zone_id: "tests-in.space"},
          %Dnsimple.ZoneRecord{content: "2A03:B0C0:0003:00D0:0000:0000:224F:5001", created_at: nil, id: nil, name: "", parent_id: nil, priority: nil, regions: nil, system_record: nil, ttl: nil, type: "AAAA", updated_at: nil, zone_id: "tests-in.space"}
        ]
      }
    ]
  end

  def record(records, type) do
    Enum.find(records, &(&1.type == type))
  end
end
