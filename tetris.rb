# frozen_string_literal: true

require './collide'
require './init'
require 'pry'
require './keyboard_input'
require 'logger'

LOGFILE = 'log_tetris.log'

class Game
  attr_accessor :grid

  def initialize(_test = false)
    @logger = Logger.new(LOGFILE)
    @logger.info('Game start')
    @quit_flag = false
    @game_over_flag = false
    @score = 0
    @grid = BOARD.mcopy
    @guys = []
    @start_pos = [2, COLS / 2 - 1] # starting position of tet
    @turn = 0 # 0 is first piece, 1 is 2nd...
    @subturn = 0 # each subturn, piece descends
    # @interval = 1 # time between subturns
    @subturn_frames = 3
    @frame_time = 0.1 # @inteval.to_f/@subturn_frames
    @move = nil
    @tet = nil
    @level = 1

    start
  end

  def start
    system('clear')
    draw
    game_loop
  end

  def game_loop
    while true
      turn_loop
      exit if @quit_flag == true
      break if @game_over_flag == true
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
    if @game_over_flag
      puts "GAME OVER. TURN: #{@turn}. SCORE: #{@score}"
      puts "T #{@turn}, ST #{@subturn}, TET #{@tet}, pos #{@pos}"
      pretty(@grid)
      pretty(@turn_state)
    end
    puts 'bye!' if @quit_flag == true
  end

  # turn_loop: from block appearing until block immobile
  def turn_loop
    # @tet = TET_2ROW#.sample
    @tet = TETS.sample
    @logger.info("turn #{@turn}")
    STDIN.iflush
    @turn_state = @grid.mcopy # save state at start of turn(each block is turn)
    @pos = @start_pos.mcopy
    @subturn = 0
    subturn_loop
    # check for full row
    increase_score(process_completed_lines)
  end

  def subturn_loop
    loop do # subturn loop: block descends each subturn
      break if @quit_flag == true

      @logger.info("T #{@turn}, ST #{@subturn}, TET #{@tet}, pos #{@pos}")

      test_grid = @turn_state.mcopy.collide(@tet, @pos.mcopy) # if @turn < 2
      # logger.info("test_grid, #{pretty(test_grid)}")
      # test_grid = test_collide(@turn_state, @tet, @pos.mcopy) #if @turn > 1

      if test_grid.nil?
        @game_over_flag = true
        break

        # couldnt place first piece, maybe cuz lost the game
        # break
      else
        @grid = test_grid
      end
      draw("T: #{@turn}, ST: #{@subturn}") # draws the block down the next row
      # draw # first draw of turn
      frame_loop # block can move once per frame

      @logger.info("THREE @pos: #{@pos}")
      @logger.info("increasing to row #{@pos[0]}")
      @logger.info("@pos: #{@pos}")

      @pos[0] += 1 if @subturn > 0
      test_grid = @turn_state.mcopy.collide(@tet, @pos.mcopy)
      if test_grid.nil? # if dropping row makes collision
        @turn_state = @grid.mcopy
        @turn += 1
        break
      else
        @grid = test_grid
        @subturn += 1
      end

      draw("T: #{@turn}, ST: #{@subturn}") # draws the block down the next row
      # sleep @interval
    end
  end

  # frame_loop: player can move block once per frame
  def frame_loop
    row = @pos[0]; col = @pos[1]
    @subturn_frames.times do |frame| # subsubturn
      test_pos = get_move(@pos)
      break if @quit_flag == true

      if test_pos
        @logger.info("@pos: #{@pos}, test_pos: #{test_pos}")
        test_grid = @turn_state.mcopy.collide(@tet, test_pos.mcopy)
        # @logger.info(test_grid.to_s)
        unless test_grid.nil?
          @pos = test_pos.mcopy
          @grid = test_grid.mcopy
        end
        @logger.info("TWO @pos: #{@pos}, test_pos: #{test_pos}")
        draw("T: #{@turn}, ST: #{@subturn}, F: #{frame}, m: #{@move}, p: #{@pos}, score: #{@score}") # call only if moved
        @move = nil
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
      if i > 1
        row.each_with_index do |_col, j|
          print array[i][j]
        end
      end
      puts if i > 1
    end
    # now loop through pieces, move cursor to their
    # position and draw.  clipping is checked elsewhere
    # print "\e[#{x};#{y}H"
    # print TET  # =>

    puts 'hjkl to move'
    STDIN.echo = false
    # STDIN.iflush
    STDIN.raw!
  end
end

Game.new
