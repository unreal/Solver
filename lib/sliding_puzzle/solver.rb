module SlidingPuzzle
  class Solver

    include CommonMethods

    attr_reader :game

    GOAL_ARRAY = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 0]
    ]

    OPPOSITES = {
      up:    :down,
      down:  :up,
      left:  :right,
      right: :left
    }

    def initialize(game)
      @game = game
    end

    # This is from a discussion thread here:
    # https://www.allegro.cc/forums/thread/307339
    def manhattan_distance(target)
      sum = 0
      target.flatten.each do |number|
        sum += distance(number, target)
      end

      sum
    end

    # Public: Returns the manhattan distance array for a given array
    def md_array(target)
      md_array = [[],[],[]]

      target.each_index do |row_index|
        target[row_index].each_index do |col_index|
          md_array[row_index][col_index] =
            distance(target[row_index][col_index], target)
        end
      end

      md_array
    end

    # Provides the # of moves required to get from a number's current
    # position to the goal position
    def distance(number, container)
      goal_location    = location(number, GOAL_ARRAY)
      current_location = location(number, container)

      distance_away(goal_location, current_location)
    end

    # Locations are given as [row,col] from #location
    def distance_away(start_location, end_location)
      (start_location[0] - end_location[0]).abs +
        (start_location[1] - end_location[1]).abs
    end


    # Public: tries each possible move direction
    #
    # Examples:
    #
    #   @solver.try_moves
    #   # => {
    #     up:   13,
    #     down: 12,
    #     left: 12
    #   }
    #
    # Returns a hash with the manhattan distance corresponding to each direction
    def try_moves
      result = {}

      @game.possible_moves.each do |direction|
        matrix = @game.try_move(direction)
        md_ary = md_array(matrix)
        md = manhattan_distance(md_ary)
        result[direction] = md
      end

      result
    end

  end
end
