# frozen_string_literal: true

require './gfx'
require './collide'
require './init'
require 'pry'
require './goo'

origin = [10, 20]

grid = BOARD.dup

class Game
  def initialize

    @quit_flag = false
    @grid = BOARD.dup
    @guys = []
    @start_pos = [0, COLS / 2 - 1] # starting position of tet
    @turn = 0 #0 is first piece, 1 is 2nd...
    @subturn = 0 # each subturn, piece descends
    @interval = 1 # time between subturns
    @interval_frames = 3
    @frame_time = 0.3#@inteval.to_f/@interval_frames

    system('clear')
    draw
    game_loop
  ensure

  end
  def game_loop
    #while true
      turn_loop

    #end
    
  ensure
  STDIN.echo = true
  STDIN.cooked!
  puts "bye!" if @quit_flag == true
  end

  def turn_loop
    turn_state = BOARD.mcopy # save state at start of turn(each block is turn)
    @pos ||= @start_pos
    #put first piece in position
    test_grid = turn_state.mcopy.merge(TET, @pos)
        if test_grid.nil?
          # couldnt place first piece
          #turn_state = @grid
          #@turn += 1
          #break
        else
          @grid = test_grid
        end
    draw # first draw of turn
    
    loop do #subturn loop
      row = @pos[0] ; col = @pos[1]
      @interval_frames.times do |frame| #subsubturn
        move = key_pressed
        if move
          print "move: #{move[0]}"
          #sleep 1
          case move
          when 'h' || '\e[D'
            puts "h"
            col -= 1
          when 'j'
            row += 1
          when 'l'
            col += 1
          when 'q'
            @quit_flag = true
            break
          end
          @pos = [row, col]
          test_grid = turn_state.mcopy.merge(TET, @pos)
          @grid = test_grid
          draw("T: #{@turn}, ST: #{@subturn}, F: #{frame}, m: #{move}, p: #{@pos}") # call only if moved

          # if reaches bottom, next turn
          # 
        end
        STDIN.raw!
        sleep @frame_time
      end
      break if @quit_flag == true
      row += 1 if @subturn > 0
      @pos = [row, col]
      test_grid = turn_state.mcopy.merge(TET, @pos)
      # draw(turn_state, "turn_state2#{turn_state.object_id}")
        if test_grid.nil?
          turn_state = @grid
          @turn += 1
          break
        else
          @grid = test_grid
          @subturn += 1
        end

      draw("T: #{@turn}, ST: #{@subturn}")
      #sleep @interval
    end

  end

  def draw(msg = 'TETRIS', array = @grid)
    system('clear')
    STDIN.cooked!
    # puts "T E T R I S".center(COLS)
    puts msg.center(COLS)
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
    STDIN.echo = false
    STDIN.raw!
  end
end

Game.new
