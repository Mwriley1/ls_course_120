# frozen_string_literal:true

class Participant
  attr_accessor :name, :hand

  def initialize
    @hand = []
  end

  def display_hand
    hand.map(&:to_s).join(', ')
  end

  def stay
    puts self.class == Player ? "You have chosen to stay." : "The Dealer stays."
    puts ""
  end

  def busted?
    card_total > 21
  end

  def card_total
    hand_total = 0

    hand.each do |card|
      hand_total += 10 if ['King', 'Queen', 'Jack'].include?(card.value)
      hand_total += 11 if card.value == 'Ace'
      hand_total += card.value.to_i
    end

    hand.select { |card| card.value == 'Ace' }.count.times do
      hand_total -= 10 if hand_total > Game::WIN_TOTAL
    end

    hand_total
  end
end

class Player < Participant
end

class Dealer < Participant
  attr_reader :deck, :player

  def initialize
    @deck = Deck.new
    @player = Player.new
    @name = ['Bob', 'Joe', 'Luke', 'Penny', 'Sarah', 'Rachel'].sample
    super
  end

  def shuffle
    deck.cards.shuffle!
  end

  def deal
    2.times do |_|
      player.hand << deck.deal_a_card
      hand << deck.deal_a_card
    end
  end

  def administer_hit
    puts "You have chosen to hit."
    puts ""
    player.hand << deck.deal_a_card
  end

  def hit
    puts "#{name} has chosen to hit."
    puts ""
    hand << deck.deal_a_card
  end

  def display_visible_hand
    hand_string = hand.map(&:to_s)
    hand_string[0] = '?'
    hand_string.join(', ')
  end

  def return_cards(hand1, hand2)
    deck.cards += (hand1 + hand2)
  end
end

class Card
  SUITS = %w(Hearts Diamonds Clubs Spades).freeze
  VALUES = %w(Ace King Queen Jack 10 9 8 7 6 5 4 3 2).freeze

  attr_reader :value

  def initialize(value = VALUES.sample, suit = SUITS.sample)
    @value = value
    @suit = suit
  end

  def to_s
    "#{@value} of #{@suit}"
  end
end

class Deck
  DECK_CARDS = Card::VALUES.product(Card::SUITS).freeze

  attr_accessor :cards

  def initialize
    @cards = add_all_cards
  end

  def add_all_cards
    deck = []
    DECK_CARDS.each do |card|
      deck << Card.new(*card)
    end
    deck
  end

  def deal_a_card
    cards.shift
  end

  def to_s
    cards.collect(&:to_s)
  end
end

class Game
  WIN_TOTAL = 21

  attr_reader :dealer, :player

  def initialize
    @dealer = Dealer.new
    @player = dealer.player
  end

  def play
    display_welcome_message
    set_player_name

    loop do
      deal_cards
      display_visible_cards

      player_turn
      dealer_turn

      display_result
      game_reset
      break unless play_again?
    end

    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to 21!"
    puts ""
  end

  def set_player_name
    answer = ""
    loop do
      puts "Please enter your name."
      answer = gets.chomp
      break if answer != ""
      puts "Sorry, you must enter something."
    end
    player.name = answer
  end

  def deal_cards
    system 'clear'
    dealer.shuffle
    puts "Dealing a new hand..."
    puts ""
    dealer.deal
  end

  def display_visible_cards
    puts "#{player.name}'s Cards: [#{player.display_hand}]  Total: #{player.card_total}"
    puts "#{dealer.name}'s Cards (Dealer): [#{dealer.display_visible_hand}]  Card Total: ?"
    puts ""
  end

  def display_all_cards
    puts "#{player.name}'s Cards: [#{player.display_hand}]  Total: #{player.card_total}"
    puts "#{dealer.name}'s Cards (Dealer): [#{dealer.display_hand}] Total: #{dealer.card_total}"
    puts ""
  end

  def player_turn
    until player.busted?
      puts "Would you like to hit or stay? (h / s)"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if ['h', 's'].include?(answer)
        puts "Sorry, that is not a valid choice."
      end

      system 'clear'
      
      if answer == 'h'
        dealer.administer_hit
        display_visible_cards
      else
        player.stay
        display_all_cards
        break
      end
    end
  end

  def dealer_turn
    until player.busted?
      if dealer.card_total < 17
        dealer.hit
        display_all_cards
        break if dealer.busted?
      else
        dealer.stay
        break
      end
    end
  end

  def display_result
    if player.busted?
      puts "You have busted.  You lose!"
    elsif dealer.busted?
      puts "The dealer has busted.  You win!"
    elsif player.card_total > dealer.card_total
      puts "You win!"
    elsif player.card_total < dealer.card_total
      puts "You lose!"
    else
      puts "It's a push!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again?"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, you must enter 'y' or 'n'."
    end
    answer == 'y'
  end

  def game_reset
    dealer.return_cards(player.hand, dealer.hand)
    player.hand = []
    dealer.hand = []
  end

  def display_goodbye_message
    puts "Thanks for playing 21! Goodbye."
  end
end

Game.new.play
