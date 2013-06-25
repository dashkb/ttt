module TTT
  class AI
    def initialize(game)
      @game = game
    end

    def coords_to_space(x, y)
      x * 3 + y
    end

    def pick_space
      player = @game.next_player
      opponent = player == 'x' ? 'o' : 'x'

      if move = winning_move(player)
        return TTT::Game::SPACES[coords_to_space(*move)]
      end

      # block
      if move = winning_move(opponent)
        return TTT::Game::SPACES[coords_to_space(*move)]
      end

      # if all corners are open we want one
      corners = @game.pieces_at(*TTT::Game::CORNERS)
      if corners.all? { |p| p == '-'}
        return 'a1'
      end

      # if opponent has a corner and the center is open
      # we want it
      if corners.any? { |p| p == opponent } && @game.piece_at('b2') == '-'
        return 'b2'
      end

      # if opponent has a corner pair they may have
      # an opportunity to fork
      if pairs = corner_pairs(opponent).any?
        # play the center if it's open
        if @game.piece_at('b2') == '-'
          return 'b2'
        else
          # don't play a corner
          sides = @game.pieces_at(*TTT::Game::SIDES)
          return TTT::Game::SIDES[sides.index('-')]
        end
      end

      # else, just pick the first open space
      idx = @game.to_a.flatten.index('-')
      TTT::Game::SPACES[idx]
    end

    def corner_pairs(piece)
      [['a1', 'c3'], ['a3', 'c1']].select do |pair|
        @game.pieces_at(*pair).all? { |p| p == piece }
      end
    end

    def winning_move(piece)
      move = nil
      rows = @game.to_a

      # two on a row with an open space
      rows.each_with_index do |row, idx|
        if row.count(piece) == 2 && row.count('-') == 1
          move = [idx, row.index('-')]
        end
      end

      # two on a col with an open space
      rows.transpose.each_with_index do |col, idx|
        if col.count(piece) == 2 && col.count('-') == 1
          move = [col.index('-'), idx]
        end
      end

      # corner pair and center open
      center_open = @game.piece_at('b2') == '-'
      if corner_pairs(piece).any? && center_open
        move = [1, 1]
      end

      # center and corner with other corner open
      has_center = rows[1][1] == piece

      if has_center
        corner = rows[0][0] == piece ? [0, 0] : nil
        corner ||= rows[0][2] == piece ? [0, 2] : nil
        corner ||= rows[2][0] == piece ? [2, 0] : nil
        corner ||= rows[2][2] == piece ? [2, 2] : nil

        if corner
          other_corner = [corner[0] == 0 ? 2 : 0, corner[1] == 0 ? 2 : 0]
          if rows[other_corner[0]][other_corner[1]] == '-'
            move = other_corner
          end
        end
      end

      move
    end
  end
end
