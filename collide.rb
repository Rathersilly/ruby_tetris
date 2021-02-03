# frozen_string_literal: true
require 'logger'
require 'rubygems'
require 'bundler/setup'
require 'bundler'
require 'pry'
require 'pry-nav'

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
    #log.info("entering collision")
    #log.info(pretty(ary))
    row = pos[0]; col = pos[1]
    item.each_index do |r|
      item[0].each_index do |c|
        #log.info("#{p ary_pix}, #{p item_pix}, r: #{r}, c: #{c}")
            #log.info("wtf")
            #log.info(pretty(ary))# WTF INDEED
        
        if item[r][c] != ' ' #if this pixel of item isnt empty
          if ary[row+r][col+c] == ' ' #no collision
            ary[row + r][col + c] = item[r][c]
            #log.info("HERE#{ary_pix}, #{item_pix}, r: #{r}, c: #{c}, item_pix: #{item_pix}")
            #log.info("HERE#{ary_pix}, #{item_pix}, row+r: #{row+r}, col+c: #{col+c}, item_pix: #{item_pix}")
            #log.info(pretty(ary))

          else #collision
            
            #log.info("collision: #{row+r},#{col+c}, ary_pix: #{ary_pix}, item_pix: #{item_pix}")
            # log.info("row: #{row}, col: #{col}")
            #log.info(pretty(ary))
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
    completed_rows = []       #stores the indices of completed rows
    anim_array = @grid.mcopy

    @grid.each_with_index do |row, i|
      if !row.include?(" ") && i != @grid.size  - 1
        completed_rows << i
        anim_array[i] = COMPLETED_ROW

      end
    end
    completed_rows.reverse.each do |i|
      @grid.delete_at(i)
    end
    completed_rows.size.times do |i|
      @grid.unshift(EMPTY_ROW.mcopy)
    end
    if !completed_rows.empty?
      draw('OMG', anim_array)
      sleep 0.2
      draw('GOOD JOB', @grid)
      log = Logger.new(LOGFILE)
      
      log.info("THIS IS @grid after unshifting")
      log.info(pretty(@grid))
    end
    return completed_rows.size
  end
  def increase_score(n)
    if n == 1
      @score += 100 * @level
    elsif n == 2
      @score += 300 * @level
    elsif n == 3
      @score += 500 * @level
    elsif n == 4
      @score += 800 * level
    end
  end

end

def test_collide(array,item, pos)
  ary_pix = ''
  item_pix = ''
  
  ary = array.mcopy
  row = pos[0]; col = pos[1]
  item.each_index do |r|
    item[0].each_index do |c|
      ary_pix = ary[row+r][col+c]
      item_pix = item[r][c]
      if item_pix != ' ' #if this pixel of item isnt empty
        if ary_pix == ' ' #no collision
          ary[row + r][col + c] = item_pix  
        else #collision
          return nil
        end
      end


    end
  end
  ary
end
