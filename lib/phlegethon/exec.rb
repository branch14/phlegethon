require 'yaml'

require 'json'
require 'thin'
require 'bunny'

require 'pp'

module Phlegethon
  class Exec < Struct.new(:config)

    attr_accessor :exchange

    def run
      init_bunny
      server = Thin::Server.new(config.endpoint.host,
                                config.endpoint.port,
                                handler)
      server.start
    end

    def handler
      ->(env) {
        pp env
        req = Rack::Request.new(env)

        # perform some business logic on posted data
        message = deep_encode({
          'params'      => req.params,
          'method'      => req.request_method,
          'url'         => req.url,
          'user_agent'  => req.user_agent
        })
        case req.content_type
        when 'application/json'
          message['payload'] = JSON.parse(req.body.read)
        else
          message = deep_encode(env)
        end
        exchange.publish(JSON.unparse(message))
        # TODO make debug response configurable
        [200, {'Content-Type' => 'text/plain'}, message.to_yaml]
      }
    end

    # TODO steal recoonect from simon or monitoring in vr_dev
    def init_bunny
      opts = {
        read_timeout: 10,
        heartbeat: 10,
        host: config.rabbitmq.host
      }
      bunny = Bunny.new(opts)
      bunny.start
      bunny_channel = bunny.create_channel
      self.exchange = bunny_channel.fanout(config.rabbitmq.exchange)
    end

    # TODO move to gem trickery
    def deep_encode(data, enc='UTF-8')
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
