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
          init_game
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
        code = @request.params["guess_code"]
        res = game.valid_code?(code) ? game.guess(code) : "No valid"
        res << "|" + game.attempts.to_s
        Rack::Response.new(res)
      when "/use_hint"
        Rack::Response.new(game.use_hint)
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

  def score
    @request.session[:score]
  end

  def init_game
    @request.session[:game] = Codebreaker::Game.new
    File.exists?("./public/score.dat") ?  @request.session[:score] = Marshal.load(File.open("./public/score.dat")) :  @request.session[:score] = []
    game.start
  end

  def res_game
    "#{user}|#{game.attempts}|#{game.instance_variable_get(:@secret_code)}|#{game.res}\n"
  end

  def load_score(f = "./public/score.dat")
    if File.exists?(f)
      str = ""
      score.each do |player|
        arr_player = player.split("|")
        str << "<tr><td>#{arr_player[0]} </td> <td> #{arr_player[1]} </td> <td>#{arr_player[2]} </td><td> #{arr_player[3].strip} </td></tr>"
      end
      str
    else
     "No score yet"
    end
  end

  def save_score(f = "./public/score.dat")
    score << res_game
    File.write(f, Marshal.dump(score))
  end


end
