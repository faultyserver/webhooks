require "json"

module Handlers
  abstract class Handler
    abstract def handle(params : HTTP::Params | JSON::Any, target)
  end

  TYPES = {} of String => Handler

  macro def_handler(name)
    class {{name.id}} < Handler
      def handle(params : HTTP::Params | JSON::Any, target)
        {{yield}}
      end
    end

    TYPES["{{name.id}}"] = {{name.id}}.new
  end
end

require "./handlers/*"
