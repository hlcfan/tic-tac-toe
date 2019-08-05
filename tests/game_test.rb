require 'minitest/autorun'
require 'timeout'
require 'pty'
require_relative '../game'

class TestGame < Minitest::Test

  def setup
    command = %q(ruby -e "load 'game.rb';Game.new([1,2,3,4,5,6,7,8,9], 3).start")
    @pty = PTY.spawn(command)
  end

  def test_initializing_users
    run_command @pty, "Alex\n"
    assert_equal(fetch_stdout(@pty), "Enter name for Player 2\r\n")
    run_command @pty, "Bob\n"
    assert_equal(fetch_stdout(@pty), "Alex, choose a box to place an 'X' into:\r\n")
  end

  def test_winning_case
    run_command @pty, "Alex\n"
    run_command @pty, "Bob\n"
    run_command @pty, "1"
    run_command @pty, "5"
    run_command @pty, "2"
    run_command @pty, "4"
    run_command @pty, "3"
    assert_equal(fetch_stdout(@pty), "Congratulations Alex! You have won.\r\n")
  end

  def test_invalid_input
    run_command @pty, "Alex\n"
    run_command @pty, "Bob\n"
    run_command @pty, "18\n"
    run_command @pty, "18\n"
    assert_equal(fetch_stdout(@pty, 2), "Invalid input range\r\nAlex, choose a box to place an 'X' into:\r\n")
    run_command @pty, "0"
    assert_equal(fetch_stdout(@pty, 2), "Invalid input range\r\nAlex, choose a box to place an 'X' into:\r\n")
    run_command @pty, "abc"
    assert_equal(fetch_stdout(@pty, 2), "Invalid input\r\nAlex, choose a box to place an 'X' into:\r\n")
  end

  def test_even_case
    run_command @pty, "Alex\n"
    run_command @pty, "Bob\n"
    run_command @pty, "1"
    run_command @pty, "4"
    run_command @pty, "7"
    run_command @pty, "2"
    run_command @pty, "3"
    run_command @pty, "5"
    run_command @pty, "6"
    run_command @pty, "9"
    run_command @pty, "8"
    assert_equal(fetch_stdout(@pty), "Board is full, existing.\r\n")
  end

  private

  def run_command pty, command
    stdout, stdin, pid = @pty
    stdin.puts command
    sleep(0.2)
    stdout.readline
  end

  def fetch_stdout pty, message_items=1
    stdout, stdin, pid = @pty
    res = []
    while true
      begin
        Timeout::timeout 0.2 do
          res << stdout.readline
        end
      rescue EOFError, Errno::EIO, Timeout::Error
        break
      end
    end

    res[-message_items..-1].join
  end
end

