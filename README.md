# DNSimple DigitalOcean connector add-on

This add-on connects your DNSimple domain to a DigitalOcean droplet. Given you want to connect your droplet to `awesome.space` It sets the following records:
- CNAME www.awesome.space awesome.space
- A record to droplet IPv4
- AAAA record to droplet IPv6 _(if available)_

## Development

To start the Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

After you followed the steps above use `mix test` to run the tests.

## Contribute

If you have a great idea for a contribution we love to see it. If it's a small enhancement, please feel free to open a PR. If it's a bigger change or feature please open a issue upfront so we can discuss it.
