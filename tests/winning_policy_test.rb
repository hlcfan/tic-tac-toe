require 'pry'
require 'minitest/autorun'
require_relative '../policies/winning_policy'

class TestWinningPolicy < Minitest::Test

  def setup
    board = (1..16).to_a
    game_size = 4
    @policy = WinningPolicy.new board.size, game_size
  end

  def test_check
    board = %w( X X X X )
    assert_equal true, @policy.check(board)

    board = %w( O X X X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 X X X X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 5 6 7 8 X X X X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 5 6 7 8 9 10 11 12 X X X X )
    assert_equal true, @policy.check(board)
  end

  def test_check_cols
    board = %w( X 2 3 4 X 6 7 8 X)
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 X 6 7 8 X 10 11 12 X )
    assert_equal true, @policy.check(board)

    board = %w( 1 X 3 4 5 X 7 8 9 X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 5 6 X 8 9 10 X 12 13 14 X )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 O 5 6 7 O 9 10 X O 13 14 X )
    assert_equal true, @policy.check(board)
  end

  def test_check_diagonals
    board = %w( O 2 3 4 5 O 7 8 X 10 O )
    assert_equal true, @policy.check(board)

    board = %w( 1 2 O 4 O X O 8 9 10 X 12 13 X O X)
    assert_equal true, @policy.check(board)

    board = %w( 1 2 O X 5 6 X 8 9 X X 12 13 X O X)
    assert_equal true, @policy.check(board)

    board = %w( 1 2 3 4 5 6 X 8 9 X X 12 X O O X)
    assert_equal true, @policy.check(board)
  end
end
