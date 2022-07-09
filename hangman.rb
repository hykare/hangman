class Hangman
  attr_reader :secret_word
  attr_accessor :word, :guesses_left

  def initialize
    @secret_word = pick_word
    @word = '_' * secret_word.length
    @guesses_left = 15
  end

  def pick_word
    dictionary = File.readlines 'google-10000-english-no-swears.txt'
    words = dictionary.filter { |word| word.length.between?(6, 13) } # counting newline
    words[rand(words.length)].chomp
  end

  def print_word
    puts word.split('').join(' ')
  end

  def play_round
    puts "guesses left: #{guesses_left}"
    print_word
    puts 'guess a letter:'
    # TODO: validate input, disable enter
    guess = gets.chomp.downcase

    if @secret_word.include? guess
      secret_word.each_char.with_index do |char, i|
        word[i] = guess if char == guess
      end
    end

    self.guesses_left -= 1
  end
end

game = Hangman.new
game.play_round while game.guesses_left.positive?
puts "the word was #{game.secret_word}"
