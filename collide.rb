# frozen_string_literal: true
require 'logger'

LOGFILE = 'log_collision.log'
class Array
  def mcopy
    Marshal.load(Marshal.dump(self)) 
  end

  # collide returns new array if no collision
  # return original if collision
  # returns a status (make error?) if bottomed out
    # item is 2d array to be inserted
    # pos is [x,y]
  def collide(item, pos)
    log = Logger.new(LOGFILE)
    
    ary = self.mcopy
    collision = nil
    row = pos[0]; col = pos[1]

    item[0].size.times do |i|
      item.size.times do |j|
        ary_pix = ary[row+i][col+j]
        item_pix = item[i][j]
        
        if item_pix != ' ' #if this pixel of item isnt empty
          if ary_pix == ' ' #no collision
            ary[row + i][col + j] = item[i][j]

          else #collision
            log.info("collision found: #{pos}")
            return nil
          end
        end


          
          #if ary[row+i] > ary.size #reached bottom
            #return 0 
          #elsif row + i == 0 || row + i == ary.size - 1 # side
            #return self
          #ary[row + i][col + j] = item[i][j]
      end
    end
    ary
  end
end

  def display(msg = 'TETRIS', array = @grid)
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
