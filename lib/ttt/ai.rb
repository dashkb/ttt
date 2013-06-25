module TTT
  class AI
    def initialize(game)
      @game = game
    end

    def pick_space
      player = @game.next_player

      # first, just pick the first open space
      idx = @game.to_a.flatten.index('-')
      TTT::Game::SPACES[idx]
    end
  end
end
