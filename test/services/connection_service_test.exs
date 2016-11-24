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

  def record(records, type) do
    Enum.find(records, &(&1.type == type))
  end
end
