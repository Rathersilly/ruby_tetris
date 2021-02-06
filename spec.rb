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
  after(:each) do
    STDIN.cooked!
  end

  it 'merges 2d array at position' do
    pos = [3, 4]
    x = 3; y = 4
    @grid = @grid.mcopy.collide(TET_O, pos)
    expect(@grid[x][y]).to eq(TET_O[0][0])
    expect(@grid[x + 1][y + 1]).to eq(TET_O[1][1])
  end

  it 'should return nil if out of bounds' do
    # collide should jk
    pos = [3, (@grid[0].size - 1)]
    # @grid = @grid.mcopy.collide(TET_O, pos)
    expect(@grid.collide(TET_O, pos)).to eq(nil)
  end

  it 'should detect completed rows' do
    @grid[ROWS - 2] = s2da('#' + 'T' * (COLS - 2) + '#')
    @grid[ROWS - 3] = s2da('#' + 'T' * (COLS - 2) + '#')
    expect(@game.process_completed_lines).to eq(2)
  end
end
