# frozen_string_literal: true

require './gfx'
require './collide'
require './init'
require 'pry'
require './goo'
require 'logger'

LOGFILE = 'log_tetris.log'

class Game
  attr_accessor :grid

  def initialize(test = false)
    @logger = Logger.new(LOGFILE)
    @quit_flag = false
    @grid = BOARD.mcopy
    @guys = []
    @start_pos = [0, COLS / 2 - 1] # starting position of tet
    @turn = 0 # 0 is first piece, 1 is 2nd...
    @subturn = 0 # each subturn, piece descends
    # @interval = 1 # time between subturns
    @subturn_frames = 3
    @frame_time = 0.3 # @inteval.to_f/@subturn_frames
    @move = nil

    system('clear')
    draw
    game_loop unless test == true
  end

  def game_loop
    @pos = @start_pos
    # while true
    turn_loop

    # end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    puts 'bye!' if @quit_flag == true
  end

  def turn_loop # turn_loop: from block appearing until block immobile
    @turn_state = @grid.mcopy # save state at start of turn(each block is turn)
    subturn_loop
  end

  def subturn_loop
    loop do # subturn loop: block descends each subturn
      break if @quit_flag == true

      test_grid = @turn_state.mcopy.collide(TET_O, @pos)
      if test_grid.nil?
        # couldnt place first piece, maybe cuz lost the game
        # break
      else
        @grid = test_grid
      end
      # draw # first draw of turn
      frame_loop # block can move once per frame

      @logger.info("THREE @pos: #{@pos}")
      @logger.info("increasing to row #{@pos[0]}")
      @logger.info("@pos: #{@pos}")

      @pos[0] += 1 if @subturn > 0
      test_grid = @turn_state.mcopy.collide(TET_O, @pos) #
      if test_grid.nil? # if dropping row makes collision
        @turn_state = @grid.mcopy
        @turn += 1
        # break
      else
        @grid = test_grid
        @subturn += 1
      end

      draw("T: #{@turn}, ST: #{@subturn}") # draws the block down the next row
      # sleep @interval
    end
  end

  def frame_loop # frame_loop: player can move block once per frame
    row = @pos[0]; col = @pos[1]
    @subturn_frames.times do |frame| # subsubturn
      test_pos = get_move(@pos)
      break if @quit_flag == true
      if test_pos
        @logger.info("@pos: #{@pos}, test_pos: #{test_pos}")
        test_grid = @turn_state.mcopy.collide(TET_O, test_pos)
        @logger.info(test_grid.to_s)
        unless test_grid.nil?
          @pos = test_pos
          @grid = test_grid
        end
        @logger.info("TWO @pos: #{@pos}, test_pos: #{test_pos}")
        draw("T: #{@turn}, ST: #{@subturn}, F: #{frame}, m: #{@move}, p: #{@pos}") # call only if moved

        # if reaches bottom, next turn
        #
      end
      STDIN.raw!
      sleep @frame_time
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
