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
    log.info("entering collision")
            log.info(pretty(ary))
    collision = nil
    row = pos[0]; col = pos[1]
    item[0].size.times do |c|
      item.size.times do |r|
        ary_pix = ary[row+r][col+c]
        item_pix = item[r][c]
        
        if item_pix != ' ' #if this pixel of item isnt empty
          if ary_pix == ' ' #no collision
            ary[row + r][col + c] = item[r][c]

          else #collision
            
            log.info("collision: #{pos}, ary_pix: #{ary_pix}, item_pix: #{item_pix}")
            log.info("row: #{row}, col: #{col}")
            log.info(pretty(ary))
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
class Game
  def process_completed_lines
    # from grid[-2][
    completed_rows = []
    anim_array = @grid.mcopy

    @grid.each_with_index do |row, i|
      if !row.include?(" ") && i != @grid.size  - 1
        completed_rows << i
        anim_array[i] = COMPLETED_ROW # row.map { |x| x == "#" ? "#" : "*" } 

      end
    end
    completed_rows.reverse.each do |i|
      @grid.delete_at(i)
    end
    completed_rows.size.times do |i|
      @grid.unshift(EMPTY_ROW)
    end
    if !completed_rows.empty?
      draw('OMG', anim_array)
      sleep 1
      draw('GOOD JOB', @grid)
      log = Logger.new(LOGFILE)
      
      log.info("THIS IS @grid after unshifting")
      log.info(pretty(@grid))
    end
    return completed_rows.size

  end
end

