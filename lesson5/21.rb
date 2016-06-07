module Hand
  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end


class Participant
  attr_accessor :name, :hand

  def initialize
    @hand = []
  end
end

class Player < Participant
  include Hand

  def initialize
    @name = "Player"
    super
  end 
end

class Dealer < Participant
  include Hand

  def initialize
    @name = ['Bob', 'Joe', 'Luke', 'Penny', 'Sarah', 'Rachel'].sample
    super
  end
end

class Card
  SUITS = %w(Hearts Diamonds Clubs Spades)
  VALUES = %w(Ace King Queen Jack Ten Nine Eight Seven Six Five Four Three Two)

  def initialize(value = VALUES.sample, suit = SUITS.sample)
    @value = value
    @suit = suit
  end

  def to_s
    "#{@value} of #{@suit}"
  end
end

class Deck
  DECK_CARDS = (Card::VALUES.product(Card::SUITS)).freeze

  attr_accessor :cards

  def initialize
    @cards = []
    fill
    shuffle
  end

  def fill
    DECK_CARDS.each do |card|
      cards << Card.new(*card)
    end
  end

  def deal
    cards.pop
  end

  def shuffle
    cards.shuffle!
  end
end

class Game
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    display_welcome_message
    deal_cards
    show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
    # play_again?
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to 21!"
    puts ""
  end

  def deal_cards
    2.times do |_|
      @player.hand << @deck.deal
      @dealer.hand << @deck.deal
    end
  end

  def show_initial_cards
    puts "Player Cards: [#{@player.hand[0]}, ?]" 
    puts "Dealer Cards [#{@dealer.hand[0]}, ?]"
  end

  def display_goodbye_message
    puts "Thanks for playing 21! Goodbye."
  end
end

Game.new.play








