require 'spec_helper'

describe TTT::Game do
  let(:game) { TTT::Game.new(TEST_DIR) }
  let(:repo) { Grit::Repo.new(TEST_DIR) }

  describe '.new' do
    it 'should create a directory at the specified path' do
      expect {
        game
      }.to change {
        Dir.exists?(TEST_DIR)
      }.from(false).to(true)
    end

    it 'knows the names of each space in Tic Tac Toe' do
      TTT::Game::SPACES.should == %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}
    end

    it 'should fill the created directory with a folder per board space' do
      game
      TTT::Game::SPACES.map do |space|
        File.join(TEST_DIR, space)
      end.each do |space|
        Dir.exists?(space).should == true
      end
    end

    it 'initializes a git repo in the created directory' do
      game
      Dir.chdir(TEST_DIR) do
        expect {
          repo
        }.to_not raise_exception(Grit::InvalidGitRepositoryError)
      end

      repo.commits.length.should == 1
    end
  end


  describe '#play' do
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

    it 'commits the move to the git repository' do
      game.play('x', 'a1')
      repo.commits.length.should == 2
    end

    it 'will not place a piece over an existing piece' do
      game.play('x', 'a1')
      expect {
        game.play('o', 'a1')
      }.to raise_exception(TTT::OccupiedSpace)
    end

    it 'will not allow a player to play out of turn' do
      game.play('x', 'a1')

      expect {
        game.play('x', 'a2')
      }.to raise_exception(TTT::NotYourTurn)
    end
  end

  describe '#next_player' do
    it 'is initially x' do
      game.next_player.should == 'x'
    end

    it 'is o after x plays' do
      game.play('x', 'a1')
      game.next_player.should == 'o'
    end
  end


  describe '#to_a' do
    it 'returns an array representation of the board' do
      game.play('x', 'a1')
      game.play('o', 'b2')
      game.play('x', 'c1')
      game.to_a.should == [
        %w{x - -},
        %w{- o -},
        %w{x - -}
      ]
    end
  end
end
