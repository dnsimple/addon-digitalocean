defmodule DigitalOceanConnector.ConnectionService do

  alias DigitalOceanConnector.DigitalOcean
  alias DigitalOceanConnector.Dnsimple, as: DnsimpleGateway

  def create_connection(domain_name, droplet_id, account) do
    DigitalOcean.get_droplet(account.digitalocean_access_token, droplet_id)
    |> DigitalOcean.get_ips_from_droplet
    |> get_zone_records(domain_name)
    |> submit(account, domain_name)
  end

  def get_connections(account) do
    droplets = DigitalOcean.list_droplets(account.digitalocean_access_token)
    domains = DnsimpleGateway.domains(account)
    |> Enum.map(fn(domain) -> Task.async(fn -> {domain, DnsimpleGateway.get_records(account, domain.name)} end) end)
    |> Enum.map(&(Task.await/1))

    find_connections(domains, droplets)
  end

  def find_connections(domains, droplets) do
    Enum.map(domains, fn ({domain, records}) ->
      {domain, Enum.find(droplets, fn(droplet) -> if has_matching_records?(records, domain, droplet), do: droplet, else: nil end), records}
    end)
    |> Enum.filter(fn ({domain, droplet, _records}) -> droplet end) # filter when droplet is nil
    |> Enum.map(fn({domain, droplet, records}) ->
      records = matching_records(records, domain, droplet)
      |> Tuple.to_list
      |> Enum.filter(&(&1))
      {domain, droplet, records}
    end)
  end

  defp matching_records(records, domain, droplet) do
    ips = Enum.into(DigitalOcean.get_ips_from_droplet(droplet), %{})
    cname_record = Enum.find(records, &(&1.type == "CNAME" && &1.name == "www") && &1.content == domain.name)
    a_record = Enum.find(records, &(&1.type == "A" && &1.name == "" && &1.content == ips["v4"] ))
    aaaa_record = Enum.find(records, &(&1.type == "AAAA" && &1.name == "" && &1.content == ips["v6"] ))

    {cname_record, a_record, aaaa_record}
  end

  defp has_matching_records?(records, domain, droplet) do
    {cname_record, a_record, aaaa_record} = matching_records(records, domain, droplet)
    !!cname_record && (!!a_record || !!aaaa_record)
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
