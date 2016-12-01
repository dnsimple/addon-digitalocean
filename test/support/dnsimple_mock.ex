defmodule DigitalOceanConnector.Dnsimple.OauthMock do
  def exchange_authorization_for_token(_client, _attributes) do
    {:ok, %Dnsimple.Response{data: %{access_token: "access-token", account_id: "1234"}}}
  end
end

defmodule DigitalOceanConnector.Dnsimple.IdentityMock do
  def whoami(_client) do
    {:ok, %Dnsimple.Response{data: %{account: %{id: 1, email: "user@example.com"}}}}
  end
end

defmodule DigitalOceanConnector.Dnsimple.DomainsMock do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def stub_domains(domains) when is_list(domains) do
    Agent.update(__MODULE__, fn _ -> domains end)
  end

  def all_domains(_client, _opts) do
    {:ok, Agent.get_and_update(__MODULE__, &({&1, []}))}
  end

  def get_domain(_client, _account_id, name) do
    {:ok, %Dnsimple.Response{data: %Dnsimple.Domain{name: name}}}
  end
end
