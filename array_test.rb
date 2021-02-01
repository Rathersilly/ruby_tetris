def pretty(array)
  array.each do |x|
    p x
  end
end
ary_pix = ''
item_pix = ''
ary = Array.new(12) {Array.new(10) {|x| x = " " } }
item = []
2.times {|i| item << %w[x x x x x]}
row = 0; col = 1
pretty item

  item.each_index do |r|
    item[0].each_index do |c|
      ary_pix = ary[row+r][col+c]
      item_pix = item[r][c]
    if item_pix != ' ' #if this pixel of item isnt empty
      if ary_pix == ' ' #no collision
        ary[row + r][col + c] = item_pix  
        p ary[row + r][col + c]
        sleep 0.1
      else
        puts "collision"
      end
    end
    end
  end

pretty(ary)






