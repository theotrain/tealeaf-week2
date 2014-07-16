class Card
  attr_accessor :suit, :value
  
  def initialize(s,v)
    self.suit = s
    self.value = v
  end

  def to_s
    "This is the card: #{self.suit}, #{self.value}"
  end
end

class Deck
  attr_accessor :cards

  def initialize(num_decks)
    @cards = []
    
    ['H','D','S','C'].each do |suit|
      ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each do |value|
        @cards << Card.new(suit,value)
      end
    end
    @cards = @cards * num_decks
    @cards.shuffle!
  end

  def deal(hand)
    hand << @cards.pop
  end
end

class Hand
  #Hand manages a group of Card objects, it can return its point value and display itself
  attr_accessor :cards
  def initialize
    #@cards is an array of Card objects, each with a :suit and :value
    @cards = []
  end

  def draw
    c1 = c2 = c3 = c4 = c5 = ""
    @cards.each do |c|
      spacer = c.value.length < 2 ? " " : ""
      c1 += "+----+  "
      c2 += "|    |  "
      c3 += "|#{spacer}#{c.value}#{c.suit.downcase} |  "
      c4 += "|    |  "
      c5 += "+----+  "
    end
    puts c1, c2, c3, c4, c5
  end

  def length 
    cards.length
  end

  def point_value
    total = 0
    #add 10 for face cards and face value for number cards and 11 for aces
    @cards.each do |c|
      if c.value == "A"
        total += 11
      elsif c.value.to_i == 0
        total += 10
      else
        total += c.value.to_i 
      end
    end
    aces = @cards.select { |c| c.value == "A"}
    aces.each do
      if total > 21
        total -= 10
      end
    end
    total
    end
end

class Player
  #player has a hand
  attr_accessor :hand

  def initialize
    self.hand = Hand.new
  end

end

class Dealer
  #dealer has a hand
  attr_accessor :hand

  def initialize
    self.hand = Hand.new
  end
end

class Blackjack
#orchestrates the game
  def initialize
    @deck = Deck.new(4)
    @player = Player.new
    @dealer = Dealer.new
  end

  def deal_card(person)
    @deck.deal(person.hand.cards)
  end

  def show_cards
    system 'clear'
    puts '----------- Dealer Cards ----------- '
    @dealer.hand.draw
    puts ''
    puts '----------- Player Cards ----------- '
    @player.hand.draw
    puts ''
    puts "You have #{@player.hand.point_value}"
    if @dealer.hand.length > 1
      puts "Dealer has #{@dealer.hand.point_value}"
    end
  end

  def reset_hands
    @player.hand = Hand.new
    @dealer.hand = Hand.new
  end

  def play_again
    begin
    puts "play again? (y/n)"
    answer = gets.chomp.downcase
    if answer == 'y'
      self.run
    elsif answer == 'n'
      puts "Thanks for nothing."
      exit
    end
    puts "type y or n.  its not that difficult."
    end until (answer == 'y' || answer == 'n')
  end

  def player_turn
    begin
      puts "Would you like to (1)hit or (2)stay?"
      answer = gets.chomp
      if answer == '1'
        deal_card(@player)
        show_cards
      end
      if @player.hand.point_value >= 21
        break
      end
    end until answer == '2'

    player_value = @player.hand.point_value
    if player_value == 21 
      puts 'You WIN!'
      play_again
    elsif player_value > 21
      puts 'You busted.'
      play_again
    end
  end

  def dealer_turn
    player_value = @player.hand.point_value
    while @dealer.hand.point_value < player_value
       deal_card(@dealer)
    end
  end

  def choose_winner
    dealer_value = @dealer.hand.point_value
    player_value = @player.hand.point_value
    if dealer_value > 21
      puts 'Dealer busted, you win!'
    elsif dealer_value == player_value
      puts "It's a tie.  You lose sucka."
    elsif dealer_value > player_value
      puts "You lose, loser."
    else
      puts "You WIN!"
    end
  end

  def run
    reset_hands
    deal_card(@player)
    deal_card(@player)
    deal_card(@dealer)
    show_cards
    if @player.hand.point_value == 21 
      puts "You got blackjack!"
      play_again
    end
    player_turn
    dealer_turn
    show_cards
    choose_winner
    play_again
  end
end

#run this shit
Blackjack.new.run