# frozen_string_literal:true

require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    @squares = {}
    reset
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |int| @squares[int] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize

  def draw
    puts "   |   |  "
    puts " #{@squares[1]} | #{@squares[2]} | #{@squares[3]}"
    puts "   |   |  "
    puts "------------"
    puts "   |   |  "
    puts " #{@squares[4]} | #{@squares[5]} | #{@squares[6]}"
    puts "   |   |  "
    puts "------------"
    puts "   |   |  "
    puts " #{@squares[7]} | #{@squares[8]} | #{@squares[9]}"
    puts "   |   |  "
  end

  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '.freeze

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  @@number_of_players = 0

  attr_reader :marker
  attr_accessor :score, :name

  def initialize(marker)
    @marker = marker
    @score = 0
    @@number_of_players += 1
    @name = "Player #{@@number_of_players}"
  end
end

class TTTGame
  HUMAN_MARKER = "X".freeze
  COMPUTER_MARKER = "O".freeze
  FIRST_TO_MOVE = HUMAN_MARKER.freeze

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    display_welcome_message
    set_player_names

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board
      end

      update_score
      display_result
      break unless play_again?
      game_reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer

  def display_welcome_message
    puts "Welcome to Tic Tac Toe."
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe.  Goodbye."
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{human.name} is #{human.marker}.  #{computer.name} is #{computer.marker}."
    puts ""
    board.draw
    puts ""
    display_score
    puts ""
  end

  def joinor(array, delimiter=', ', conjunction='or ')
    delimiter = ' ' if array.length < 3
    selectable_squares = array.join(delimiter)
    selectable_squares.insert(selectable_squares.length - 1, conjunction) if array.length > 1
    selectable_squares
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)})."
    square = nil

    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that is not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    if @current_marker == HUMAN_MARKER
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "The Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    play_again = nil
    
    loop do
      puts "Would you like to play again? (y/n)"
      play_again = gets.chomp.downcase
      break if ['y', 'n'].include?(play_again)
      puts "Sorry, that is not a valid choice."
    end

    play_again == 'y'
  end

  def clear
    system 'clear'
  end

  def game_reset
    board.reset
    clear
    @current_marker = FIRST_TO_MOVE
  end

  def display_play_again_message
    puts "Let's play again."
    puts ""
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def update_score
    if board.winning_marker == HUMAN_MARKER 
      human.score += 1 
    elsif board.winning_marker == COMPUTER_MARKER
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name}'s Score: #{human.score} #{computer.name}'s Score: #{computer.score}"
  end

  def set_player_names
    puts "Please enter your name."
    answer = gets.chomp
    human.name = answer unless answer == ''
    computer.name = ['Bob', 'Joe', 'Bill', 'Marty', 'Alice', 'Ashley', 'Vera'].sample
  end
end

game = TTTGame.new
game.play
