require 'grit'

module TTT
  class IllegalPiece  < StandardError; end
  class IllegalSpace  < StandardError; end
  class OccupiedSpace < StandardError; end
  class GameExists    < StandardError; end
  class NotYourTurn   < StandardError; end
  class GameOver      < StandardError; end

  class Game
    SPACES = %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}
    BOARD = [
      %w{a1 a2 a3},
      %w{b1 b2 b3},
      %w{c1 c2 c3}
    ]

    # Create a Tic Tac Toe game at the
    # specified directory
    def self.create(dir)
      self.new(dir).tap do |game|
        game.build_board
      end
    end

    def initialize(dir)
      @dir = dir
    end

    def build_board
      begin
        Dir.mkdir(@dir)
      rescue Errno::EEXIST
        raise GameExists
      end

      Dir.chdir(@dir) do
        SPACES.each do |space|
          File.join(@dir, space).tap do |space_dir|
            Dir.mkdir(space_dir)
            Dir.chdir(space_dir) do
              `touch -`
            end
          end
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
      raise GameOver if over?
      raise NotYourTurn unless next_player == piece
      raise OccupiedSpace unless Dir.entries(
        File.join(@dir, space)
      ).include?('-')

      Dir.chdir(@dir) do
        path = File.join(space, piece)
        `echo #{piece} > #{path}`
        `git add #{path}`
        `git rm -f #{File.join(space, '-')}`
        `git commit -m "#{piece} placed on #{space}"`
      end
    end

    def to_a
      Dir.chdir(@dir) do
        BOARD.map do |row|
          row.map do |space|
            # the dir should only have ['.', '..', piece]
            Dir.entries(File.join(@dir, space))[2]
          end
        end
      end
    end

    def next_player
      raise GameOver if over?

      pieces = to_a.flatten
      xs = pieces.count('x')
      os = pieces.count('o')

      if xs == os
        'x'
      else
        'o'
      end
    end

    def over?
      return true if to_a.flatten.count('-') == 0
      return true if won?('x') || won?('o')

      false
    end

    def piece_at(space)
      idx = SPACES.flatten.find_index(space)
      to_a.flatten[idx]
    end

    def won?(piece)
      # win on row?
      return true if to_a.any? do |row|
        row.all? { |p| p == piece }
      end

      # win on column?
      return true if to_a.transpose.any? do |col|
        col.all? { |p| p == piece }
      end

      # win diagonally?
      has_center = piece_at('b2') == piece
      has_corner_pair = [['a1', 'c3'], ['c1', 'a3']].any? do |pair|
        pair.all? { |space| piece_at(space) == piece }
      end

      return true if has_center && has_corner_pair

      # nope
      false
    end

    def draw?
      over? && !won?('x') && !won?('o')
    end

    # true if we are in a TTT game
    def self.present?
      files = Dir.entries(Dir.pwd)

      (SPACES).all? do |file|
        files.include?(file)
      end
    end

    def self.opposite_corner(space)
      out = ''

      if space[0] == 'a'
        out += 'c'
      else
        out += 'a'
      end

      if space[1] == '1'
        out += '3'
      else
        out += '1'
      end

      out
    end
  end
end
