require "json"

module Handlers
  abstract class Handler
    abstract def handle(params : HTTP::Params)
  end

  TYPES = {} of String => Handler

  macro def_handler(name)
    class {{name.id}} < Handler
      def handle(params : HTTP::Params)
        {{yield}}
      end
    end

    TYPES["{{name.id}}"] = {{name.id}}.new
  end
end

require "./handlers/*"
