require 'spec_helper'

describe TTT::Game do
  let(:game) { TTT::Game.create(TEST_DIR) }
  let(:repo) { Grit::Repo.new(TEST_DIR) }

  describe '.create' do
    it 'should create a directory at the specified path' do
      expect {
        game
      }.to change {
        Dir.exists?(TEST_DIR)
      }.from(false).to(true)
    end

    it 'will not clobber an existing game' do
      game

      expect {
        TTT::Game.create(TEST_DIR)
      }.to raise_exception(TTT::GameExists)
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

  describe '.present' do
    it 'checks cwd for a tic tac toe game' do
      TTT::Game.present?.should == false

      game
      Dir.chdir(TEST_DIR) do
        TTT::Game.present?.should == true
      end
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

  context 'endgame' do
    let(:draw) {[
      %w{x x o},
      %w{o o x},
      %w{x o x}
    ]}

    let(:win_row) {[
      %w{x x x},
      %w{o o -},
      %w{o - -}
    ]}

    let(:win_col) {[
      %w{x o o},
      %w{x - x},
      %w{x x o}
    ]}

    let(:win_diag) {[
      %w{x o o},
      %w{o x x},
      %w{- o x}
    ]}

    describe '#over?' do
      it 'returns false when the game has not ended' do
        game.over?.should == false
        game.play('x', 'a1')
        game.over?.should == false
      end

      it 'returns true when the board is full' do
        game.stub(:to_a).and_return(draw)
        game.over?.should == true
      end

      it 'returns true when a player has won the game' do
        [win_row, win_col, win_diag].each do |win|
          game.stub(:to_a).and_return(win)
          game.over?.should == true
        end
      end
    end

    describe 'won?' do
      it 'returns true when a player has won the game' do
        [win_row, win_col, win_diag].each do |win|
          game.stub(:to_a).and_return(win)
          game.won?('x').should == true
          game.won?('o').should == false
        end
      end
    end

    describe 'draw?' do
      it 'returns true when a the game has ended in a draw' do
        game.stub(:to_a).and_return(draw)
        game.draw?.should == true
      end
    end
  end
end
