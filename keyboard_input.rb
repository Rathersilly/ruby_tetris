require 'io/console'
require 'io/wait'
require 'logger'
#  STDIN.echo = false
#  STDIN.raw!
def key_pressed #char_if_pressed
  if STDIN.ready?
    input = STDIN.read_nonblock(1) rescue nil
    @logger.info("INPUT input: #{input}, class: #{input.class}") if !input.nil?
    if input == "\e" 
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
      #@logger.info("JJJJJJJJtemp: #{temp}, input: #{input}, class: #{input.class}") if !input.nil?
    end
  end
  # STDIN.cooked!
  @logger.info("input: #{input}, class: #{input.class}") if !input.nil?
  input

end

class Game
  def get_move(test_pos) # return uu
    row = test_pos[0]; col = test_pos[1]
    @move = key_pressed
    if @move
      @logger.info( "move: #{@move}")
      # sleep 1
      case @move[0]
      when 'h' || '\e[D'
        puts 'h'
        col -= 1
      when 'j'
        if @move[1] == 'j'
          @logger.info("jj")
          #drop to bottom
        end
        row += 1
      when 'k'
        
        row -= 1
      when 'l'
        col += 1
      when 'z' # rotate counter-clockwise
        # test_grid = @grid.mcopy.collide(@tet.rotate(-1
        # @grid = 
      when 'x' # rotate clockwise
      when 'v' # hold piece
      when ' ' # drop hard
      when "\u0003"
        exit
      when 'q'
        @quit_flag = true
      end
    else
      return nil
    end
    test_pos = [row, col]

    return test_pos
  end

  

end

