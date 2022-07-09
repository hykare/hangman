class Hangman
  attr_reader :secret_word
  attr_accessor :word, :guesses_left, :message

  def initialize
    @secret_word = pick_word
    @word = '_' * secret_word.length
    @guesses_left = 15
    @message = ''
  end

  def pick_word
    dictionary = File.readlines 'google-10000-english-no-swears.txt'
    words = dictionary.filter { |word| word.length.between?(6, 13) } # counting newline
    words[rand(words.length)].chomp
  end

  def print_word
    puts word.split('').join(' ')
  end

  def play
    play_round until over?
    show_result
  end

  def play_round
    puts "guesses left: #{guesses_left}"
    print_word
    puts 'guess a letter:'
    # TODO: validate input, disable enter
    guess = gets.chomp.downcase

    # update word
    if @secret_word.include? guess
      secret_word.each_char.with_index do |char, i|
        word[i] = guess if char == guess
      end
    end
    self.guesses_left -= 1
    # check for game end
  end

  def over?
    self.message = "Congratulations! You won! The word was \"#{secret_word}\"" if word == secret_word
    self.message = "You failed. The word was \"#{secret_word}\"" if guesses_left.zero?
    word == secret_word || guesses_left.zero?
  end

  def show_result
    puts message
  end
end

game = Hangman.new
game.play
