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

      # first, just pick the first open space
      idx = @game.to_a.flatten.index('-')
      TTT::Game::SPACES[idx]
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
      has_corners = rows[0][0] == piece && rows[2][2] == piece
      has_corners ||= rows[0][2] == piece && rows[2][0] == piece
      center_open = rows[1][1] == '-'
      if has_corners && center_open
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
