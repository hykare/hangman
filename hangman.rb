dictionary = File.readlines 'google-10000-english-no-swears.txt'
words = dictionary.filter { |word| word.length.between?(5, 12) }
secret_word = words[rand(words.length)]

