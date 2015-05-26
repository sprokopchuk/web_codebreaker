require 'spec_helper'

module Codebreaker
  describe Game do
    let(:game) {Game.new}
    context "#start" do

      before do
        game.start
      end

      it "saves secret code" do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(game.instance_variable_get(:@secret_code)).to have(4).items
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it "begin a new game with new secret code" do
        sec_code1 = game.instance_variable_get(:@secret_code)
        game.start
        expect(sec_code1).not_to eq(game.instance_variable_get(:@secret_code))
      end

      it "begin a new game with 5 number of turns" do
        expect(game.attempts).to eq(5)
      end

      it "begin a game with one hint for reveal one number" do
        expect(game.hint).to be_truthy
      end

    end

    context "#guess" do
      before do
        game.start
        game.instance_variable_set(:@secret_code, "6664")
      end

      it "make a guess when number in the same position" do
        expect(game.guess(1234)).to match("+")
      end

      it "make a guess when number in the different position" do
        expect(game.guess(1243)).to eq("-")
      end

      it "make a guess when number is missing in secret code" do
        expect(game.guess(1233)).to eq("")
      end

      it "make a guess when number is longer or less than 4 characters" do
        expect{game.guess("12345")}.to raise_error(ArgumentError, "must be four numbers")
        expect{game.guess("123")}.to raise_error(ArgumentError, "must be four numbers")
      end

      it "make a guess when code exact match as secret code" do
        expect(game.guess(6664)).to eq("Win!")
        expect(game.revealed_nums).to eq("++++")
        expect(game.res). to eq("Win!")
      end

      it "make a guess when code exact match as secret code" do
        game.instance_variable_set(:@attempts, 0)
        expect(game.guess(6654)).to eq("Lose!")
        expect(game.res).to eq("Lose!")
      end

      it "make a guess and chnage turns for reveal secret code" do
        expect{game.guess(6666)}.to change{game.attempts}.from(5).to(4)
      end

      codes = [ {code: "1335", secret_code: "1134", res: "++"},
                {code: "6464", secret_code: "6141", res: "+-"},
                {code: "5412", secret_code: "5431", res: "++-"},
                {code: "6565", secret_code: "5566", res: "++--"},
                {code: "3124", secret_code: "3312", res: "+--"},
                {code: "2113", secret_code: "1234", res: "---"},
                {code: "5263", secret_code: "6344", res: "--"},
                {code: "6134", secret_code: "3614", res: "+---"},
                {code: "6321", secret_code: "1632", res: "----"},
                {code: "5412", secret_code: "3466", res: "+"},
                {code: "5463", secret_code: "1232", res: "-"},
                {code: "2164", secret_code: "2154", res: "+++"}
              ]

      codes.each do |i|
        it "make a guess when secret code is #{i[:secret_code]} and guess code is #{i[:code]}" do
          game.instance_variable_set(:@secret_code, i[:secret_code])
          expect(game.guess(i[:code])).to eq(i[:res])
        end
      end
    end

    context "#use_hint" do
      it "begin a game with one hint" do
        expect(game.hint).to be_truthy
      end

      it "when no hint if it is used" do
        game.use_hint
        expect(game.hint).to be_falsey
      end

      it "to reveal one of numbers in secret code" do
        expect(game.use_hint).to eq(game.instance_variable_get(:@secret_code)[0])
      end

      it "when no hint if it uses again" do
        game.use_hint
        expect(game.use_hint).to be_falsey
      end
    end
  end
end
