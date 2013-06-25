require 'thor'
require 'colorize'

module TTT
  class CLI < Thor
    desc 'new PATH', 'start a new tic tac toe repo'
    def new(path)
      absolute_path = File.join(Dir.pwd, path)

      begin
        TTT::Game.new(absolute_path)
      rescue TTT::GameExists
        puts "Refusing to overwrite existing game at #{absolute_path}".red
        exit 1
      end

      puts(
        "Created new Tic Tac Toe game repo at #{absolute_path}".green
      )
    end
  end
end
