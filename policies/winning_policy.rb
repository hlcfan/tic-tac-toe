class WinningPolicy

  def initialize board_size, game_size
    @board_size = board_size
    @game_size = game_size
  end

  def check board
    conditions.each do |condition|
      combination = condition.map do |point|
        board[point]
      end

      if combination.all?("X") || combination.all?("O")
        return true
      end
    end

    false
  end

  private

  def conditions
    @conditions ||= begin
                      winning_rows + winning_cols + winning_diagonals
                    end
  end

  def winning_rows
    size = @board_size - 1
    0.upto(size).each_slice(@game_size).to_a
  end

  def winning_cols
    size = @board_size - 1
    winning_cols = []
    0.upto(size).each do |i|
      winning_cols[i%@game_size] ||= []
      winning_cols[i%@game_size] << i
    end

    winning_cols
  end

  def winning_diagonals
    size = @board_size - 1

    [
      0.upto(@game_size-1).map do |i|
        i*@game_size + i
      end,
      0.upto(@game_size-1).map do |i|
        i*@game_size + @game_size - i - 1
      end
    ]
  end
end

