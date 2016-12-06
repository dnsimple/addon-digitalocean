defmodule DigitalOceanConnector.ConnectionServiceMock do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def stub_connections(connections) when is_list(connections) do
    Agent.update(__MODULE__, fn _ -> connections end)
  end

  def get_connections(_account) do
    Agent.get_and_update(__MODULE__, &({&1, []}))
  end

  def create_connection(_domain_name, _droplet_id, _account), do: nil
end
