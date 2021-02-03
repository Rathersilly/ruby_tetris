require 'io/console'
require 'io/wait'
require 'logger'
require 'date'
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
        col -= 1
      when 'j'
        row += 1
      when 'k'
        row -= 1
      when 'l'
        col += 1
      when 'z' # rotate counter-clockwise
        test_tet = @tet.mcopy.transpose.reverse
        test_grid = @turn_state.mcopy.collide(test_tet, @pos.mcopy)
        unless test_grid.nil?
          @grid = test_grid.mcopy
          @tet = test_tet.mcopy
        end
      when 'x' # rotate clockwise
        test_tet = @tet.mcopy.reverse.transpose
        test_grid = @turn_state.mcopy.collide(test_tet, @pos.mcopy)
        unless test_grid.nil?
          @grid = test_grid.mcopy
          @tet = test_tet.mcopy
        end
      when 'v' # hold piece
      when ' ' # drop hard
      when 'p' # enter pause mode
        pause_mode
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

  def pause_mode
    STDIN.cooked! 
    loop do
      puts "Pause mode: enter command (p to resume)"
      puts "type: sav (filename) to export board to file"
      response = gets.chomp
      break if response == 'p'
      if response.start_with?('sav')
        filename = response.match(/sav (.*)/)[1]
        filename += ".asdf"
        File.open(filename, "w") do |f|
          f.print "TETRIS! - "
          f.print DateTime.now
          f.puts"T: #{@turn}, ST: #{@subturn}, m: #{@move}, p: #{@pos}, score: #{@score}"
          @grid.each_with_index do |row, i|
            if i > 1
              row.each_with_index do |col, j|
                f.print @grid[i][j]
              end
            end
            f.puts if i > 1
          end
        end
      end
    end
    STDIN.raw!
  end



end

