require "http"
require "json"
require "yaml"

# See `./env.example.yaml` for what goes in this file.
config = YAML.parse(File.open("./env.yaml"))


server = HTTP::Server.new(2017) do |context|
  # The webhook provider shouldn't care what we do with the request
  context.response.content_type = "text/plain"
  context.response.status_code = 204

  if body = context.request.body
    params = HTTP::Params.parse(body.gets_to_end)

    # See https://discordapp.com/developers/docs/resources/webhook#execute-webhook
    # for a reference of Discord's webhook payload format.
    unless params["git_log"] && !params["git_log"].empty?
      params["git_log"] = "commit message not provided."
    end

    if params["prev_head"]
      params["prev_head"] = params["prev_head"][0, 8]
    end

    discord_payload = {
      "embeds" => [{
        "title" => params["url"],
        "url" => params["url"],
        "description" => params["git_log"],
        "color" => 0x79589f,
        "author" => {
          "name" => params["user"]
        },
        "fields" => [
          {
            "name" => "previous head",
            "value" => params["prev_head"],
            "inline" => true
          },
          {
            "name" => "new head",
            "value" => params["head"],
            "inline" => true
          },
          {
            "name" => "release",
            "value" => params["release"]? || "not specified",
            "inline" => true
          }
        ],
        "timestamp" => Time.now
      }]
    }.to_json

    # Send the formatted webhook payload to Discord.
    HTTP::Client.post(config["discord_target"].to_s, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: discord_payload)
  end
end

server.listen
