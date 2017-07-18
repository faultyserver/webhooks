require "json"
require "yaml"

require "kemal"

require "./handler"


REGISTERED_HOOKS = {} of String => Handlers::Handler

post "/create_hook/:type" do |env|
  hook_id = SecureRandom.hex(8)
  while REGISTERED_HOOKS[hook_id]?
    hook_id = SecureRandom.hex(8)
  end

  REGISTERED_HOOKS[hook_id] = Handlers::TYPES[env.params.url["type"]].dup
  hook_id
end

post "/execute/:hook_id" do |env|
  # The webhook provider shouldn't care what we do with the request
  env.response.content_type = "text/plain"
  env.response.status_code = 204
  hook_id = env.params.url["hook_id"]
  hook_type = ENV["#{hook_id}_type"]
  hook_target = ENV["#{hook_id}_target"]
  body = JSON.parse(env.request.body.as(IO).gets_to_end)

  Handlers::TYPES[hook_type].handle(body, hook_target)
end

Kemal.run
