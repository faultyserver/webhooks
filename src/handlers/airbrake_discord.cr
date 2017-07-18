module Handlers
  def_handler AirbrakeDiscord do

# {
#     "error": {
#         "id": "1212",
#         "error_message": "Bad Error!",
#         "error_class": "Unknown Class",
#         "file": "/testapp/app/models/user.rb",
#         "line_number": 31200,
#         "project": {
#             "id": 1001,
#             "name": "Airbrake Test Project"
#         },
#         "last_notice": {
#             "id": "12345678",
#             "request_url": "http://my-test-url1212.com",
#             "backtrace": []
#         },
#         "environment": "production",
#         "severity": "warning",
#         "first_occurred_at": "2013-06-13T11:25:58.113447Z",
#         "last_occurred_at": "2013-06-13T11:25:58.105127Z",
#         "times_occurred": 4
#     },
#     "airbrake_error_url": "https://airbrake.io/airbrake-error-url"
# }
    body = JSON.parse(env.request.body.as(IO).gets_to_end)

    discord_payload = {
      "embeds" => [{
        "title" => body["error"]["error_class"],
        "url" => body["airbrake_error_url"],
        "description" => body["error"]["error_message"],
        "color" => 0x79589f,
        "author" => {
          "name" => "#{body["error"]["file"]}:#{body["error"]["line_number"]}"
        },
        "fields" => [
            {"name" => "Environment", "value" => body["error"]["environment"], "inline" => true},
            {"name" => "Severity", "value" => body["error"]["severity"], "inline" => true},
            {"name" => "Occurrances", "value" => body["error"]["times_occurred"], "inline" => true}
        ],
        "timestamp" => body["error"]["last_occurred_at"]
      }]
    }.to_json

    # Send the formatted webhook payload to Discord.
    HTTP::Client.post(target.to_s, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: discord_payload)
  end
end
