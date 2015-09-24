# apt-get install libssl-dev
# gem install thin
# gem install eventmachine
# iptables -I INPUT -p tcp --dport 9292 -j ACCEPT
#
# thin start --ssl -p 9292
# curl -k https://localhost:9292/

require 'pp'

run Proc.new { |env|
  # Extract the requested path from the request
  req = Rack::Request.new(env)

  pp env
  pp req

  [200, {}, []]
}
