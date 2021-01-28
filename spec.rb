# frozen_string_literal: true

require './gfx.rb'
require 'pry'
describe Array do
  before(:each) do
    @grid = BOARD.dup
    @item = TET
  end

  it 'merges 2d array at position' do
    # @grid = BOARD.dup
    # @item = s2da(TET)
    pos = [3, 4]
    x = 3; y = 4
    # binding.pry
    @grid = @grid.merge(@item, pos)
    expect(@grid[x][y]).to eq(@item[0][0])
    expect(@grid[x + 1][y + 1]).to eq(@item[1][1])
  end

  it 'should return nil if out of bounds' do
    pos = [0, 11]
    x = 0; y = 11
    expect(@grid.merge(@item, pos)).to eq(nil)
  end
end
