require 'codebreaker'
require 'erb'
require 'json'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/enter_name"
      game = Codebreaker::Game.new
      game.start
      Rack::Response.new do |response|
        response.set_cookie("user", @request.params["user"])
        response.redirect("/")
      end
    when '/start_game'
      game = Codebreaker::Game.new
      game.start
      Rack::Response.new([{res_game: game.res}.to_json])
    when "/guess_code"
    else Rack::Response.new("Not Found", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def user
    @request.cookies["user"] || "Guest"
  end

  def user?
    user != "Guest"
  end

end
