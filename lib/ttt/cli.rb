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
      puts "Game is over" and return if game.over?

      piece = game.next_player

      game.play(piece, space)
      puts "Placing #{piece} on #{space}".green

      board

      if game.over?
        if game.draw?
          puts "Game ended in draw".yellow
        elsif game.won?('x')
          puts "X is the winner".green
        else
          puts "O is the winner".green
        end
      end
    end

    desc 'aiplay', 'let the computer make the next move'
    def aiplay
      play(AI.new(game).pick_space)
    end

    desc 'aishow', 'show the move the computer would make'
    def aishow
      puts AI.new(game).pick_space
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
