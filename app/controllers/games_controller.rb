require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ("A".."Z").to_a.sample }
  end

  def check_grid?(attempt, grid)
    dup_letter = attempt.detect { |x| attempt.count(x) > 1 }
    if grid.count(dup_letter) > 1
      attempt - grid == []
    else
      intersection = grid.intersection(attempt).sort
      intersection == attempt.sort
    end
  end

  def json(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = URI.open(url).read
    JSON.parse(attempt_serialized)
  end

  def run_game(attempt, grid)
    # , start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    array_attempt = attempt.upcase.chars
    check_english = json(attempt)
    # elapsed_time = end_time - start_time
    if check_grid?(array_attempt, grid)
      # check_english["found"] ? score = check_english["length"].to_f : score = 0
      message = check_english["found"] ? "Well done!" : "Not an english word"
    else
      # score = 0
      message = "Not in the grid"
    end
    { time: elapsed_time, score: score, message: message }
  end

  def score
    # raise
    @word = params[:word]
    run_game(@word, @letters)
  end
end
