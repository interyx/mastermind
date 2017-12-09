class Mastermind
  def initialize
    @timer = 12
    @secret = generate_number
    @answers = []
    @kill = false
    menu()
  end

  def menu
    puts "--------------------------"
    puts "| Welcome to MASTERMIND! |"
    puts "--------------------------"
    puts "| 1. Start New Game      |"
    puts "| 2. HELP!               |"
    puts "| 3. Quit                |"
    puts "--------------------------"
    choice = 0
    unless choice.between?(1, 3) then
      print "Your selection > "
      choice = gets.chomp.to_i
    end

    case choice
    when 1 then start_game()
    when 2 then help()
    when 3 then exit
    end
    exit
  end

  def start_game
    while !@kill do
      puts "#{@timer} guesses remaining."
      guess = Guess.new()
      guess = analyze(guess)
      @answers << guess
      print_guesses()
      @timer -= 1
      game_over("win") if guess.bulls == 4
      game_over("lose") if @timer == 0
    end
  end

  def analyze(guess)
    current_guess = guess.code
    @secret.each_with_index do |num, idx|
      if current_guess.include?(num)
        if current_guess[idx] == @secret[idx]
          guess.bulls += 1
        else
          guess.cows += 1
        end
      end
    end
    guess
  end

  def help
    puts "MASTERMIND is a code-breaking game."
    puts "The object of the game is to the SECRET CODE."
    puts "The SECRET CODE has four unique digits."
    puts "Each turn, you will guess a number, and receive feedback about how close the guess was."
    puts "You may receive two kinds of feedback, BULLS and COWS."
    puts "COWS are numbers that exist in the SECRET CODE, but are in the wrong position in your guess."
    puts "BULLS are numbers that both exist in the SECRET CODE and are in the correct position in your guess."
    puts "If the SECRET CODE is 1 2 3 4, and your guess is 2 4 3 7, you would have:"
    puts "1 BULL, the 3 in the correct place, and 2 COWS, because 2 and 4 are in the wrong place."
    puts "GOOD LUCK!"
    menu()
  end

  def generate_number
    secret = []
    while secret.size < 4 do
      secret << rand(1..9)
      secret = secret.uniq
    end
    secret
  end

  def print_guesses
    puts "------------------------------"
    @answers.each do |answer|
      puts answer
    end
    puts "------------------------------"
  end

  def game_over(status)
    @kill = true
    puts "You win!" if status == "win"
    puts "Sorry, you lost!  Better luck next time." if status == "lose"
    puts "[ENTER] to continue."
    gets.chomp
    system("clear") || system("cls")
    initialize()
  end

  class Guess
    attr_accessor :code, :bulls, :cows

    def initialize()
      @bulls = 0
      @cows = 0
      @code = take_guess
    end

    def take_guess
      input = 0
      while !input.between?(1111, 9999)
        print "Please enter a four-digit number > "
        input = gets.chomp.to_i
      end
      @code = input.to_s.each_char.map(&:to_i)
    end

    def to_s
      "| #{@code[0]}#{@code[1]}#{@code[2]}#{@code[3]} | Bulls: #{@bulls} | Cows: #{@cows} |"
    end

  end
end

mastermind = Mastermind.new()
