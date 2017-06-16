require "json"
require "yaml"

require "kemal"

require "./handler"


REGISTERED_HOOKS = {} of String => Handlers::Handler

post "/create_hook" do |env|
  hook_id = SecureRandom.hex(8)
  while REGISTERED_HOOKS[hook_id]?
    hook_id = SecureRandom.hex(8)
  end

  REGISTERED_HOOKS[hook_id] = Handlers::TYPES["HerokuDiscord"].dup
  hook_id
end

post "/execute/:hook_id" do |env|
  # The webhook provider shouldn't care what we do with the request
  env.response.content_type = "text/plain"
  env.response.status_code = 204

  REGISTERED_HOOKS[env.params.url["hook_id"]].handle(env.params.body)
end

Kemal.run
