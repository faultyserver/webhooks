# Webhook Proxy

This is a simple proxy for marrying a webhook endpoint with a provider who doesn't follow the same format (_*cough* heroku *cough*_).


## Installation

This proxy is written in [Crystal](http://crystal-lang.org), which you can install with `brew install crystal` on a mac, or `sudo apt-get install crystal` on linux.

To run the proxy locally, but test with real-world webhooks, I recommend using [`ngrok`](https://ngrok.com/download). To use it, simply download the executable and put it somewhere in your `$PATH`.

## Compiling

You need to install the dependencies with `shards`:

```
$ shards install
```

and then compile:

```
$ shards build
```

## Usage

First, set up your local environment with the appropriate endpoint definitions. You need an environment variable for the class name that implements the specific proxy type and another variable for the endpoint to proxy to:

```bash
export airbrake_type=AirbrakeDiscord
export airbrake_target=https//discordapp.com/ai/webhooks/blahblahblah
```

This will setup a proxy at url http://localhost/webhooks/airbrake that uses the `AirbrakeDiscord` handler and posts to the specified discord channel url.

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
