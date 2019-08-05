require 'minitest/autorun'
require_relative '../policies/winning_policy'

class TestWinningPolicy < Minitest::Test

  def setup
    board = (0..8).to_a
    game_size = 3
    @policy = WinningPolicy.new board.size, game_size
  end

  def test_check
    # check rows
    board = %w( X X X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 X X X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 5 6 X X X )
    assert_equal true, @policy.check(board)

    # check cols
    board = %w( X 2 3 X 5 6 X)
    assert_equal true, @policy.check(board)

    board = %w( X O 3 4 O 6 7 O)
    assert_equal true, @policy.check(board)

    board = %w( 1 2 X 4 5 X 7 8 X )
    assert_equal true, @policy.check(board)

    # check diagonals
    board = %w( X 2 3 4 X 6 7 8 X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 O 4 O 6 O 8 9 )
    assert_equal true, @policy.check(board)
  end
end
