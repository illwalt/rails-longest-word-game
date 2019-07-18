require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    # raise
    @game_result = message(@word, @grid)
  end


private

  def in_grid?(grid, attempt)
    # attempt.upcase.chars.all?{ |letter| attempt.count(letter) <= grid.count(letter) }
    attempt.split { |letter| grid.include?(letter) && attempt.upcase.count(letter) <= grid.count(letter) }
  end

  def message(attempt, grid)
    if in_grid?(attempt.upcase, grid)
      if english_word?(attempt)
        "congratulations #{attempt} is a valid english word"
      else
        "Sorry but #{attempt} does not seem to be an english word"
      end
    else
      "Sorry but #{attempt} cannot be built out of #{grid}"
    end
  end

  def english_word?(attempt)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
