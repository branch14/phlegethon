require 'yaml'

require 'json'
require 'thin'
require 'bunny'

require 'pp'

module Phlegethon
  module Exec

    DEFAULTS = {
      'rabbitmq' => {
        'exchange' => 'webhooks',
        'host' => 'localhost'
      },
      'server' => {
        'port' => 3002,
        'ssl' => false
      }
    }

    extend self

    attr_accessor :exchange

    def run(args)
      init_bunny
      # TODO make port and bind address configurable
      server = Thin::Server.new('0.0.0.0', config['server']['port'], handler)
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
      # TODO make bunny configurable
      bunny = Bunny.new read_timeout: 10, heartbeat: 10
      bunny.start
      bunny_channel = bunny.create_channel
      self.exchange = bunny_channel.fanout(config['rabbitmq']['exchange'])
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

    def config
      @config ||= DEFAULTS.merge(YAML.load(File.read(config_path)))
    end

    def config_path
      config_path_candidates.each do |f|
        if File.exist?(f)
          puts "Reading config from #{f}"
          return f
        end
      end
      warn 'config file not found'
      exit
    end

    def config_path_candidates
      [ './phlegethon.yml',
        ENV['HOME'] + '/.phlegethon.yml' ]
    end

  end
end
