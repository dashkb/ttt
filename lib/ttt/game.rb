require 'grit'

module TTT
  class IllegalPiece < StandardError; end
  class IllegalSpace < StandardError; end

  class Game
    SPACES = %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}

    # Create a Tic Tac Toe game at the
    # specified directory
    def initialize(dir)
      @dir = dir and build_board
    end

    def build_board
      Dir.mkdir(@dir)
      Dir.chdir(@dir) do
        SPACES.each do |space|
          Dir.mkdir(File.join(@dir, space))
        end

        `git init .` # error checking obvs
      end
    end

    # Place a piece at a space or raise illegal move
    def play(piece, space)
      raise IllegalPiece unless %w{x o}.include?(piece)
      raise IllegalSpace unless SPACES.include?(space)

      `touch #{File.join(@dir, space, piece)}`
    end
  end
end
