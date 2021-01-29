# frozen_string_literal: true

require 'yaml'
require './tetris'
require './collide'
require 'pry'

describe Game do
  before(:each) do
    @game = Game.new(true)
    @grid = @game.grid
  end

  it 'merges 2d array at position' do
    pos = [3, 4]
    x = 3; y = 4
    # binding.pry
    @grid = @grid.mcopy.collide(TET, pos)
    STDIN.cooked!
    $stderr.puts @grid.to_yaml
    binding.pry
    expect(@grid[x][y]).to eq(TET[0][0])
    expect(@grid[x + 1][y + 1]).to eq(TET[1][1])
  end

  it 'should return nil if out of bounds' do
    pos = [4, 0]
    STDIN.cooked!
    expect(@grid.collide(TET, pos)).to eq(nil)
  end
end
