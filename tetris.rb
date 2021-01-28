# frozen_string_literal: true

require './gfx'
require './collide'
require './init'
require 'pry'

origin = [10, 20]

grid = BOARD.dup

class Game
  def initialize

    @grid = BOARD.dup
    @guys = []
    @start_pos = [0, COLS / 2 - 1] # starting position of tet
    @turn = 0 #0 is first piece, 1 is 2nd...
    @subturn = 0 # each subturn, piece descends
    @interval = 1 # time between subturns

    @frame_delay = 0.5 # min time between movements
    system('clear')
    display
    game_loop
  end
  def game_loop
    while true
      turn_loop

    end
  end

  def turn_loop
    turn_state = BOARD.mcopy # save state at start of turn(each block is turn)
    @pos ||= @start_pos
    loop do
      # @guy = Piece.new(0,@start_pos)
      # @guy.type = 0
      
      row = @pos[0] ; col = @pos[1]
      row += 1 if @subturn > 0
      move = gets.chomp
      case move
      when 'h'
        col -= 1
      when 'j'
        row -= 1
      when 'k'
        row += 1
      when 'l'
        col += 1
      when 'q'
        break
      end
      @pos = [row, col]

      p @pos
      test_grid = turn_state.mcopy.merge(TET, @pos)

      # display(turn_state, "turn_state2#{turn_state.object_id}")
      @grid = test_grid unless test_grid.nil?
      # unmerge then merge new grid
      # @guys[@turn] = @guy
      # p @guys
      # @turn += 1
      # store piece positions in array of hashes
      # hash has id, type, position, rotation
      @subturn += 1

      display
    end

  end

  def display(array = @grid, msg = 'TETRIS')
    system('clear')
    # puts "T E T R I S".center(COLS)
    puts msg
    # go to reference coordinates
    # system "clear"
    # print "\e[0;0H"

    array.each_with_index do |row, i|
      row.each_with_index do |_col, j|
        print array[i][j]
      end
      puts
    end
    # now loop through pieces, move cursor to their
    # position and draw.  clipping is checked elsewhere
    # print "\e[#{x};#{y}H"
    # print TET  # =>

    puts 'hjkl to move'
    #gets
  end
end

Game.new
