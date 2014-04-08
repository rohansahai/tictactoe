require './tic_tac_toe_solution'

class TicTacToeNode
  attr_accessor :board, :mark, :prev_move_pos
  MARK = {:o => :x, :x => :o}

  def initialize(board, mark, prev_move_pos = nil)
    @board = board
    @mark = mark
    @prev_move_pos = prev_move_pos
  end

  def children # current state of board
    open_spots = []
    self.board.rows.each_with_index do |row, i|
      row.each_with_index do |column, j|
        if self.board.empty_spot?([i,j])
          open_spots << [i,j]
        end
      end
    end
    child_boards = []

    open_spots.each do |spot|
      board_template = self.board.dup
      board_template[spot] = self.mark
      child_boards << TicTacToeNode.new(board_template, MARK[self.mark], spot) # recursively flip mark
    end
    child_boards
  end

  def winning_node?(player)

    if self.board.winner == player
      #puts "winning node"
      return true
    elsif !self.board.over?
      new_children = self.children
      #all and any depending on whose turn it is
      if self.mark == player
        new_children.any? {|child| child.winning_node?(player)}
      else
        children.all? {|child| child.winning_node?(player)}
        #new_children.none? {|child| !child.winning_node?(player)}
      end
    else
      #puts "ain't got nothing"
      return false
    end

  end

  def losing_node?(player)
    if self.board.winner == MARK[player]
      return true
    elsif !self.board.over?
      if self.mark == player
        return self.children.all? {|child| child.losing_node?(player)}
      elsif self.mark != player
        return self.children.any? {|child| child.losing_node?(player)}
      end
    else
      return false
    end
  end
end

class ComputerPlayer
  def move(game, mark)
    start_node = TicTacToeNode.new(game.board, mark)
    start_node.children.each do |child|
      if child.winning_node?(mark)
        p mark
        p child.prev_move_pos
        p child.board
        return child.prev_move_pos
      end
    end

    start_node.children.each do |child|
      if child.losing_node?(mark) == false
        return child.prev_move_pos
      end
    end

  end
end