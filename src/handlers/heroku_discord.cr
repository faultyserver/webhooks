module Handlers
  def_handler HerokuDiscord do
    # See https://discordapp.com/developers/docs/resources/webhook#execute-webhook
    # for a reference of Discord's webhook payload format.
    # unless params["git_log"]
    #   params["git_log"] = "commit message not provided."
    # end

    # params["prev_head"] = params["prev_head"]? ? params["prev_head"][0, 8] : "not specified"

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
            "value" => params["head"].as_s[0, 8],
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
    HTTP::Client.post(target.to_s, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: discord_payload)
  end
end
