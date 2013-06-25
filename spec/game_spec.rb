require 'spec_helper'

describe TTT::Game do
  describe '.new' do
    it 'should create a directory at the specified path' do
      expect {
        TTT::Game.new(TEST_DIR)
      }.to change {
        Dir.exists?(TEST_DIR)
      }.from(false).to(true)
    end

    it 'knows the names of each space in Tic Tac Toe' do
      # this is a dumb spec but whatever, typo check
      TTT::Game::SPACES.should == %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}
    end

    it 'should fill the created directory with a folder per board space' do
      TTT::Game.new(TEST_DIR)
      TTT::Game::SPACES.map do |space|
        File.join(TEST_DIR, space)
      end.each do |space|
        Dir.exists?(space).should == true
      end
    end
  end
end
