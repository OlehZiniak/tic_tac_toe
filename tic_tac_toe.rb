class Game
  DEV = "---+---+---"
  @@keys = %i[x1 x2 x3 x4 x5 x6 x7 x8 x9]
  @@values = [1,2,3,4,5,6,7,8,9]
  @@winers = 
      [[:x1,:x2,:x3],[:x4,:x5,:x6],[:x7,:x8,:x9],[:x1,:x4,:x7],
      [:x2,:x5,:x8],[:x3,:x6,:x9],[:x3,:x5,:x7],[:x1,:x5,:x9]]
  @@win = false

  def initialize(player1, player2)
    @players = [player1, player2]
    @every_move = {player1 => [], player2 => []}
    @x_or_o = {player1 => "X", player2 => "O"}
    @field_cells = Hash[@@keys.zip(@@values)]
    generate_and_show_field
    game_in_progress
  end

  def game_in_progress
    n = 0
    until @@win
      i = n%2 == 0 ? 0 : 1
      move(@players[i])
      n+=1
      if @every_move.values.flatten.length == 9
        puts "IT'S A DRAW! NICE MATCH"
        exit
      end
    end
    puts "CONGRATULATIONS #{@players[i]}, YOU WON"; puts; exit
  end

  def generate_and_show_field
    @field = 
      [" #{@field_cells[:x7]} | #{@field_cells[:x8]} | #{@field_cells[:x9]} ",
      DEV," #{@field_cells[:x4]} | #{@field_cells[:x5]} | #{@field_cells[:x6]} ",
      DEV," #{@field_cells[:x1]} | #{@field_cells[:x2]} | #{@field_cells[:x3]} "]
    @field.each {|row| puts row}
    puts
  end

  def move_valid?(move)
    @@keys.include?(move)
  end

  def cell_occupied?(move)
    @x_or_o.values.include?(@field_cells[move])
  end

  def won?(moves_of_player)
      @@winers.each do |combination|
        @@win = true if combination.all?{|num| moves_of_player.include?(num)}
      end
    @@win
  end

  def move(player)
    puts "#{player}, please make your move"
    begin
      player_move = gets.chomp.prepend("x").to_sym; puts
      if move_valid?(player_move) && !cell_occupied?(player_move)
        @field_cells[player_move] = @x_or_o[player]
        @every_move[player] << player_move
      else
        raise ArgumentError, "NUMBER IS NOT VALID"
      end
    rescue
        puts %Q!#{player}, THIS MOVE IS NOT ALLOWED:
please check if your move is a digit from 1 to 9
and the cell is not occupied with a previous move!; puts; puts "#{player}, change your move, please!"
        retry
    end
    generate_and_show_field
    won?(@every_move[player])
  end
end

puts; puts "Hello! Welcome to the Tic-tac-toe game"; puts
puts "Player 1, please enter your name"
p1 = gets.chomp; puts
puts "Player 2, please enter your name"
p2 = gets.chomp; puts
while p1 == p2
  puts "Player 2, please pick another name. '#{p2}' is already taken by Player 1"
  p2 = gets.chomp
end
Game.new(p1, p2)
