require "codebreaker/version"
require 'codebreaker/game'

module Codebreaker
	#Some bugs in class
  class Codegame
    def initialize(name = "Player")
      @name = name
      @res_game = "Lost"
      @game = Codebreaker::Game.new
    end

    attr_accessor :name

    def start_game
      puts @game.start
      while @game.turns > 0
        puts "Secret code consists of 4 numbers! Do you wanna a guess a secret code?(y/n) Or you wanna use a hint?(hint)"
        answer = gets.chomp
        if answer == "y"
          puts "Make a guess!"
          code = gets.chomp
          puts @game.guess(code)
          if @game.win?
            puts @res_game = "Won"
            save_score
            break
          end
          if @game.over?
            puts @res_game = "Lost"
            save_score
          end
        end
        if answer == "n"
          puts @res_game = "Game was interrupted!"
          save_score
          break
        end
        puts @game.use_hint if answer == "hint"
      end
    end

    def to_s
      "#{@name}|#{@game.turns}|#{@game.secret_code}|#{@res_game}\n"
    end

    def load_score
      lines = File.readlines('score.txt')
      lines.each do |line|
        arr_player = line.split("|")
        puts "Your name: #{arr_player[0]} | Number of attempts: #{arr_player[1]} | Secret code: #{arr_player[2]} | Result of the game: #{arr_player[3].strip}" if arr_player[0] == @name
      end
    end

    def save_score
      f = File.exists?("score.txt") ? File.open("score.txt", "a") : File.new("score.txt", "a")
      f.write(self.to_s)
      puts "Score is saved!"
    end

  end
end
