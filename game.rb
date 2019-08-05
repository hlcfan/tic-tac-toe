require 'readline'
require_relative 'policies/winning_policy'
require 'pry'

class Game
  def initialize board, game_size
    @board = board
    @game_size = game_size
    @counter = 0
    @number_of_players = 2
  end

  def start
    listen_on_exit
    initialize_players

    loop do
      begin
        point = parse_user_input
        place_marker(point - 1)
        check_board_status
      rescue RuntimeError, ArgumentError, NoMethodError => e
        puts e
        retry
      end
    end
  end

  def read_input_from_stdin
    input = Readline.readline(">> ", true)
    Readline::HISTORY.pop if input == ""

    input
  end
  private

  def initialize_players
    @users = {}

    user_key = @counter % 2
    0.upto(@number_of_players - 1) do |i|
      puts "Enter name for Player #{i+1}"
      @users[i] = read_input_from_stdin
    end
  end

  def winning_policy
    @winning_policy ||= begin
                          WinningPolicy.new @board.size, @game_size
                        end
  end

  def listen_on_exit
    Signal.trap('INT') do
      exit 0
    end
  end

  def parse_user_input
    puts "#{user}, choose a box to place an '#{marker}' into:"
    input = read_input_from_stdin
    puts "===Input: #{input}"
    if !( input =~ /\A\d+\z/ )
      raise ArgumentError, "Invalid input"
    end

    point = input.to_i
    if point <= 0 || point > @board.length
      raise ArgumentError, "Invalid input range"
    end

    if ["X", "O"].include? @board[point - 1]
      raise ArgumentError, "Point taken"
    end

    point
  end


  def place_marker point
    @board[point] = marker
    check_winning
    @counter += 1
    print_board
  end

  def check_winning
    if winning_policy.check @board
      print_board
      puts "Congratulations #{user}! You have won."

      exit 0
    end
  end

  def user
    @users[@counter%2]
  end

  def marker
    if @counter % 2 == 0
      char = "X"
    else
      char = "O"
    end
  end

  def print_board
    puts
    @board.each_slice(@game_size) do |row|
      puts row.join(" | ")
      puts "-"*11
    end
    puts
  end

  def check_board_status
    if !@board.any?(Integer)
      puts "Board is full, existing."
      exit 0
    end
  end
end


# n = 4
# array = (1..16).to_a
# game = Game.new array, n
# game.start

