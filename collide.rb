# frozen_string_literal: true

class Array
  def mcopy
    Marshal.load(Marshal.dump(self)) 
  end
  def merge(item, pos)
    # item is 2d array to be inserted
    # pos is [x,y]
    ary = self.dup  # =>
    
    row = pos[0]; col = pos[1]
    item[0].size.times do |i|
      item.size.times do |j|
        # yeah gonna need better collision than that
        # return nil if ary[row + i][col + j] != " "
        ary[row + i][col + j] = item[i][j]
        # displacol(self)
      end
    end

    ary
  end
end

