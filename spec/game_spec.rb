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

    it 'initializes a git repo in the created directory' do
      TTT::Game.new(TEST_DIR)
      Dir.chdir(TEST_DIR) do
        expect {
          Grit::Repo.new(TEST_DIR)
        }.to_not raise_exception(Grit::InvalidGitRepositoryError)
      end
    end
  end


  describe '#play' do
    let(:game) { TTT::Game.new(TEST_DIR) }

    it 'requires a piece and a space' do
      expect {
        game.play('x')
      }.to raise_exception(ArgumentError)

      expect {
        game.play('a2')
      }.to raise_exception(ArgumentError)

      expect {
        game.play('x', 'a1')
      }.to_not raise_exception(ArgumentError)
    end


    it 'requires a legal piece and space' do
      expect {
        game.play('y', 'a1')
      }.to raise_exception(TTT::IllegalPiece)

      expect {
        game.play('x', 'z1')
      }.to raise_exception(TTT::IllegalSpace)
    end

    it 'places a piece by creating a file in the space directory' do
      game.play('x', 'a1')
      File.exists?(File.join(TEST_DIR, 'a1', 'x')).should == true
    end
  end
end
