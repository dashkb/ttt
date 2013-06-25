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
  end
end
