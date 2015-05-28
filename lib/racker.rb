require 'codebreaker'
require 'erb'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"
      if user?
        @request.session[:game] = Codebreaker::Game.new
        @request.session[:hint] = nil
        game.start
        Rack::Response.new(render("game.html.erb"))
      else
        Rack::Response.new(render("index.html.erb"))
      end
    when "/enter_name"
      Rack::Response.new do |response|
        response.set_cookie("user", @request.params["user"])
        response.redirect("/")
      end
    when "/guess_code"
      if game.valid_code? @request.params["guess_code"]
        game.guess(@request.params["guess_code"])
      end
      Rack::Response.new(render("game.html.erb"))
    when "/use_hint"
      @request.session[:hint] = game.use_hint
      Rack::Response.new(render("game.html.erb"))
    when "/save_score"
      save_score
      Rack::Response.new do |response|
        response.redirect("/")
      end
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

  def game
    @request.session[:game]
  end

  def hint
    @request.session[:hint]
  end

  def res_game
    "#{user}|#{game.attempts}|#{game.instance_variable_get(:@secret_code)}|#{game.res}\n"
  end

  def load_score
    lines = File.readlines('./public/score.txt')
    lines.each do |line|
      arr_player = line.split("|")
      puts "Your name: #{arr_player[0]} | Number of attempts: #{arr_player[1]} | Secret code: #{arr_player[2]} | Result of the game: #{arr_player[3].strip}" if arr_player[0] == user
    end
  end

  def save_score
    f = File.exists?("./public/score.txt") ? File.open("./public/score.txt", "a") : File.new("./public/score.txt", "a")
    f.write(res_game)
    "Score is saved!"
  end


end
