# Webhook Proxy

This is a simple proxy for marrying a webhook endpoint with a provider who doesn't follow the same format (_*cough* heroku *cough*_).


## Installation

This proxy is written in [Crystal](http://crystal-lang.org), which you can install with `brew install crystal` on a mac, or `sudo apt-get install crystal` on linux.

To run the proxy locally, but test with real-world webhooks, I recommend using [`ngrok`](https://ngrok.com/download). To use it, simply download the executable and put it somewhere in your `$PATH`.


## Usage

First, set up `env.yaml` with the appropriate endpoint definitions. Currently, only Discord is supported as an endpoint. See `env.example.yaml` for a reference of what this file should look like. In short, it looks like this:

```yaml
discord_target: https://discordapp.com/api/webhooks/#{webhook.id}/#{webhook.token}
```

With the configuration in place, just run the server with

```bash
crystal run webhooks.cr
```

Then, start an ngrok instance for http on port 2017 (the port this proxy runs on):

```bash
ngrok http 2017
```

Copy the URL that ngrok creates (something like `http://a7f6ca2.ngrok.io`) and paste that into Heroku's "HTTP Post Deploy Hook" setup.

Save and send a test message to make sure your embed is showing up properly. If the embed shows up in Discord, you should be good to go!


## Roadmap

Ideally, this will become an agnostic service for transforming webhook payloads to make them more inter-compatible. The first step is to support requests _from_ different hosts, then to support dispatching them _to_ different clients.

After those two are done, a web interface allowing users to customize payloads would be a nice-to-have, though the feasability of such a feature is debatable.
