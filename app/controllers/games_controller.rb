require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    set_letters_for_new_attempt
  end

  def score
    build_letters_to_validate_attempt
    fetch_attempt

    @message = if attempt_fits_in_available_letters?
      if attempt_is_real_word?
        "✅ Congrats! You built a real word '#{@attempt}'"
      else
        "❌ Bummer. This word '#{@attempt}' does not seem to be a real word"
      end
    else
      "🙅‍♂️ Nope. Your word '#{@attempt}' does not even fit in the letters available"
    end
  end

  private

  def fetch_attempt
    @attempt = params[:attempt]
  end

  def attempt_fits_in_available_letters?
    @attempt.chars.all? {|letter| @available_letters.include?(letter) || @available_letters.include?(letter.upcase) }
  end

  def attempt_is_real_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    res = JSON.parse(open(url).read)

    return res["found"]
  end

  def build_letters_to_validate_attempt
    @available_letters = params[:available_letters].split('')
  end

  def set_letters_for_new_attempt
    @letters = ('A'..'Z').to_a.sample(10)
  end
end
