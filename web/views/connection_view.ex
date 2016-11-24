defmodule DigitalOceanConnector.ConnectionView do
  use DigitalOceanConnector.Web, :view

  def domain_select_options(dnsimple_domains), do: Enum.map(dnsimple_domains, &({&1.name, &1.name}))
  def droplet_select_options(droplets), do: Enum.map(droplets, &({&1["name"], &1["id"]}))
end
