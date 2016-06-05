# frozen_string_literal:true

require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock'].freeze

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (rock? && other_move.lizard?) ||
      (paper? && other_move.rock?) ||
      (paper? && other_move.spock?) ||
      (scissors? && other_move.paper?) ||
      (scissors? && other_move.lizard?) ||
      (lizard? && other_move.paper?) ||
      (lizard? && other_move.spock?) ||
      (spock? && other_move.rock?) ||
      (spock? && other_move.scissors?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (rock? && other_move.spock?) ||
      (paper? && other_move.scissors?) ||
      (paper? && other_move.lizard?) ||
      (scissors? && other_move.rock?) ||
      (scissors? && other_move.spock?) ||
      (lizard? && other_move.rock?) ||
      (lizard? && other_move.scissors?) ||
      (spock? && other_move.lizard?) ||
      (spock? && other_move.paper?)
  end

  def to_s
    @value
  end
end

class History
  attr_accessor :values
  
  def initialize
    @values = []
  end

  def win_percentage(choice, other_player)
    wins = 0.00

    values.each_with_index do |move, index|
      wins += 1 if (move.to_s == choice) && (move > other_player.history.values[index])
    end
    (wins / values.length)
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = History.new
  end
end

class Human < Player
  def set_name
    name = ''
    loop do
      puts "What is your name?"
      name = gets.chomp
      break unless name.empty?
      puts "Sorry.  You must enter a value."
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts "Select rock, paper, scissors, lizard, or spock."
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts 'Sorry. That is an invalid choice.  Please select again.'
    end
    self.move = Move.new(choice)
    self.history.values << move
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose(other_player)
    best_moves = Move::VALUES.select do |value|
                   history.win_percentage(value, other_player) > 0.5
                 end
    if best_moves.empty?
      self.move = Move.new(Move::VALUES.sample)
    else
      self.move = Move.new(best_moves.sample)
    end

    self.history.values << move
  end
end

class RPSGame
  SCORE_TO_WIN = 10

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock, #{human.name}!"
    puts "The first player to reach a score of 10, wins!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock.  Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_round_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def keep_score
    if human.move > computer.move
      human.score = human.score + 1
    elsif human.move < computer.move
      computer.score = computer.score + 1
    end
  end

  def display_score
    puts "#{human.name}'s score is #{human.score}."
    puts "#{computer.name}'s score is #{computer.score}"
  end

  def display_game_winner
    puts human.score == SCORE_TO_WIN ? "#{human.name} won!" : "#{computer.name} won!"
  end

  # Test Methods

  def display_history
    p human.history
    p computer.history
  end

  def display_single_moves
    p human.history.values
    p computer.history.values
  end

  def display_rock_win_p
    p human.history.win_percentage('paper', computer)
  end

  # Test Methods End

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry.  You must select y or n."
    end

    return false if answer == 'n'
    return true if answer == 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose(human)
      display_moves
      display_round_winner
      keep_score
      display_score
      next unless human.score == SCORE_TO_WIN || computer.score == SCORE_TO_WIN
      display_game_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
