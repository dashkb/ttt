require 'grit'

module TTT
  class IllegalPiece  < StandardError; end
  class IllegalSpace  < StandardError; end
  class OccupiedSpace < StandardError; end
  class GameExists    < StandardError; end
  class NotYourTurn   < StandardError; end

  class Game
    SPACES = %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}
    BOARD = [
      %w{a1 a2 a3},
      %w{b1 b2 b3},
      %w{c1 c2 c3}
    ]

    # Create a Tic Tac Toe game at the
    # specified directory
    def initialize(dir)
      @dir = dir and build_board
    end

    def build_board
      begin
        Dir.mkdir(@dir)
      rescue Errno::EEXIST
        raise GameExists
      end

      Dir.chdir(@dir) do
        SPACES.each do |space|
          Dir.mkdir(File.join(@dir, space))
        end

        `git init .` # error checking obvs
        `echo "instructions" > README` # TODO put instructions in here
        `git add .`
        `git commit -m "New game of Tic Tac Toe"`
      end
    end

    # Place a piece at a space or raise illegal move
    def play(piece, space)
      raise IllegalPiece unless %w{x o}.include?(piece)
      raise IllegalSpace unless SPACES.include?(space)
      raise NotYourTurn unless next_player == piece
      raise OccupiedSpace unless Dir.entries(
        File.join(@dir, space)
      ).length == 2 # ['.', '..'] is empty directory

      Dir.chdir(@dir) do
        path = File.join(space, piece)
        `echo #{piece} > #{path}`
        `git add #{path}`
        `git commit -m "#{piece} placed on #{space}"`
      end
    end

    def to_a
      Dir.chdir(@dir) do
        BOARD.map do |row|
          row.map do |space|
            # the dir should only have ['.', '..', piece]
            # and piece might not be there so rescue with a dash
            Dir.entries(File.join(@dir, space))[2] || '-'
          end
        end
      end
    end

    def next_player
      pieces = to_a.flatten
      xs = pieces.count('x')
      os = pieces.count('o')

      if xs == os
        'x'
      else
        'o'
      end
    end

    # true if we are in a TTT game
    def self.present?
      files = Dir.entries(Dir.pwd)

      (SPACES).all? do |file|
        files.include?(file)
      end
    end
  end
end
