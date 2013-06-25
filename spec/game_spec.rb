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
  end
end
