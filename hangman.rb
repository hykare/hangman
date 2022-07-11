require 'yaml'

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

    guess = enter_valid_guess

    if @secret_word.include? guess
      secret_word.each_char.with_index do |char, i|
        word[i] = guess if char == guess
      end
    end
    self.guesses_left -= 1
  end

  def over?
    self.message = "Congratulations! You won! The word was \"#{secret_word}\"" if word == secret_word
    self.message = "You failed. The word was \"#{secret_word}\"" if guesses_left.zero?
    word == secret_word || guesses_left.zero?
  end

  def enter_valid_guess
    guess_valid = false
    until guess_valid
      guess = gets.chomp.downcase
      if guess == 'save'
        save
        exit
      end
      guess_valid = (guess =~ /[[:alpha:]]/) && (guess.length == 1)
    end
    guess
  end

  def save
    puts 'Enter save name:'
    file_name = gets.chomp.split.join('_')
    save_file = File.new("#{file_name}.yaml", 'w')
    save_file.puts YAML.dump(self)
    puts "Game saved as '#{file_name}.yaml'"
  end

  def self.load(file_name)
    yaml_string = File.read file_name
    YAML.safe_load(yaml_string, permitted_classes: [Hangman])
  end

  def show_result
    puts message
  end
end

def load_saved_game
  available_files = Dir.glob('*.yaml')
  if available_files.empty?
    puts 'no available save files, starting a new game'
    return Hangman.new
  end
  puts "available save files: #{available_files.join(', ')}"
  puts 'enter save name:'
  file_name = ''
  file_name = gets.chomp until available_files.include? file_name
  Hangman.load file_name
end

puts 'load saved game or start a new one? (load/new)'
game = if gets.chomp == 'load'
         load_saved_game
       else
         Hangman.new
       end
game.play
