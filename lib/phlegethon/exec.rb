require 'yaml'

require 'json'
require 'thin'
require 'bunny'

module Phlegethon
  module Exec

    # TODO make exchange or queue name configurable
    EXCHANGE = 'paypal'

    extend self

    attr_accessor :exchange

    def run(args)
      init_bunny
      # TODO make port and bind address configurable
      server = Thin::Server.new('0.0.0.0', 3002, handler)
      server.start
    end

    def handler
      ->(env) {
        # TODO perform business logic on posted data
        output = deep_encode(env, 'UTF-8')
        exchange.publish(JSON.unparse(output))
        # TODO make debug response configurable
        [200, {'Content-Type' => 'text/plain'}, output.to_yaml]
      }
    end

    # TODO steal recoonect from simon or monitoring in vr_dev
    def init_bunny
      # TODO make bunny configurable
      bunny = Bunny.new read_timeout: 10, heartbeat: 10
      bunny.start
      bunny_channel = bunny.create_channel
      self.exchange = bunny_channel.fanout(EXCHANGE)
    end

    # TODO move to gem trickery
    def deep_encode(data, enc)
      case data
      when String
        data.encode(enc)
      when Array
        data.map { |e| deep_encode(e, enc) }
      when Hash
        data.inject({}) do |r, a|
          r.merge deep_encode(a[0], enc) => deep_encode(a[1], enc)
        end
      else data
      end
    end

  end
end
