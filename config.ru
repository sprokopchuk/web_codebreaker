require "./lib/racker"

use Rack::Static, :urls => ["/stylesheets", "/js"], :root => "public"
Rack::Handler::WEBrick.run Racker, :Port => 9191
