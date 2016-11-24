defmodule DigitalOceanConnector.ConnectionService do

  alias DigitalOceanConnector.DigitalOcean

  def create_connection(domain_name, droplet_id, account) do
    DigitalOcean.get_droplet(account.digitalocean_access_token, droplet_id)
    |> DigitalOcean.get_ips_from_droplet
    |> get_zone_records(domain_name)
    |> submit(account, domain_name)
  end

  def get_zone_records(networks, domain_name, records \\ [])
  def get_zone_records([], domain_name, result) do
    Enum.reverse([
      %Dnsimple.ZoneRecord{type: "CNAME", name: "www", content: domain_name, ttl: 3600}
      | result
    ])
  end
  def get_zone_records([{"v4", ip} | records], domain_name, result) do
    get_zone_records(records, domain_name, [
      %Dnsimple.ZoneRecord{type: "A", name: "", content: ip, ttl: 3600}
      | result
    ])
  end

  def get_zone_records([{"v6", ip} | records], domain_name, result) do
    get_zone_records(records, domain_name, [
      %Dnsimple.ZoneRecord{type: "AAAA", name: "", content: ip, ttl: 3600}
      | result
    ])
  end

  def submit(records, account, domain_name) do
    DigitalOceanConnector.Dnsimple.create_records(account, domain_name, records)
  end
end
