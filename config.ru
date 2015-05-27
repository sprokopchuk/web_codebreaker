require "./lib/racker"

use Rack::Static, :urls => ["/css"], :root => "public"
use Rack::Session::Cookie, :key => 'rack.session',
                           :secret => 'prokopchuk'
run Racker
