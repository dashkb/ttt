require 'thor'
require 'colorize'


module TTT
  class CLI < Thor
    desc 'create PATH', 'start a new tic tac toe repo'
    def create(path)
      absolute_path = File.join(Dir.pwd, path)

      begin
        TTT::Game.create(absolute_path)
      rescue TTT::GameExists
        puts "Refusing to overwrite existing game at #{absolute_path}".red
        exit 1
      end

      puts(
        "Created new Tic Tac Toe game repo at #{absolute_path}".green
      )
    end

    desc 'play SPACE', 'place the next piece at SPACE'
    def play(space)
      piece = game.next_player

      game.play(piece, space)
      puts "Placing #{piece} on #{space}"

      board
    end

    desc 'board', 'show the board'
    def board
      pieces = game.to_a

      puts <<BOARD
  A B C
1 #{pieces[0][0]} #{pieces[0][1]} #{pieces[0][2]}
2 #{pieces[1][0]} #{pieces[1][1]} #{pieces[1][2]}
3 #{pieces[2][0]} #{pieces[2][1]} #{pieces[2][2]}
BOARD
    end

    private
    def game
      unless TTT::Game.present?
        puts "Please change to a directory with a tic tac toe game".red
        exit 1
      end

      TTT::Game.new(Dir.pwd)
    end
  end
end
