require 'grit'

module TTT
  class Game
    SPACES = %w{a1 a2 a3 b1 b2 b3 c1 c2 c3}

    def initialize(dir)
      Dir.mkdir(dir)
      Dir.chdir(dir) do
        SPACES.each do |space|
          Dir.mkdir(File.join(dir, space))
        end

        `git init .` # error checking obvs
      end
    end
  end
end
