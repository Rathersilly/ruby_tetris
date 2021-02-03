# frozen_string_literal: true

ROWS = 17 # left and right columns are borders
COLS = 12 # 1 row is bot border, 2 rows hidden at top

barray = Array.new(ROWS) { Array.new(COLS) }
barray.each_with_index do |row, i|
  row.each_with_index do |_col, j|
    barray[i][j] = if j == 0 || j == COLS - 1
                     '#'
                   elsif i == ROWS - 1
                     '#'
                   else
                     ' '
                   end
  end
end
BOARD = barray

class Piece
  attr_accessor :type, :pos

  def initialize(type, pos)
    @type = type
    @pos = pos
  end
end

def s2da(s) # string to 2d array
  a = []
  s.each_line do |line|
    a << line.chomp.split('')
  end
  a
end

def display2(grid)
  system('clear')
  # go to reference coordinates
  # system "clear"
  # print "\e[0;0H"

  grid.each_with_index do |row, i|
    row.each_with_index do |_col, j|
      print grid[i][j]
    end
    puts
  end

  puts
  gets
end

def pretty(array)
  array.each do |row|
    p row
  end
end

TET_O = s2da("\
OO
OO")

TET_I = s2da("\
 I  
 I  
 I  
 I  ")
TET_L = s2da("\
 L 
 L 
 LL")
TET_J = s2da("\
 J 
 J 
JJ ")
TET_S = s2da("\
   
 SS
SS ")
TET_Z = s2da("\
   
ZZ 
 ZZ")
TET_T = s2da("\
 T 
TTT
   ")
TETS = [TET_O, TET_I, TET_L, TET_J, TET_S, TET_Z]

TET_ROW = s2da("XXXXX")
TET_2ROW = s2da("\
XXXXX
XXXXX")

EMPTY_ROW = ("#" + " " * (COLS - 2) + "#").split('')
COMPLETED_ROW = ("#" + "*" * (COLS - 2) + "#").split('')
