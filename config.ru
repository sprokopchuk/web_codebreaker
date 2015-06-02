require "./lib/racker"

use Rack::Reloader
use Rack::Static, :urls => ["/css", "/js"], :root => "public"
use Rack::Session::Cookie, :key => 'rack.session',
                           :secret => 'prokopchuk'
run Racker
