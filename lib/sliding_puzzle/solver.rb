module SlidingPuzzle
  class Solver
    include CommonMethods

    attr_reader :game, :moves, :previous_states

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

      @previous_states = []
      add_state(@game.current_state)
      @moves = []
    end

    def add_state(state)
      new_state = [[],[],[]]
      new_state[0] = state[0]
      new_state[1] = state[1]
      new_state[2] = state[2]

      previous_states << new_state
    end

    def last_move
      @moves.last
    end

    def current_state
      @previous_states.last
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

    # Public: Returns true if previous states includes the given matrix
    def been_to?(matrix)
      previous_states.each do |state|
        return true if matrix[0] == state[0] &&
          matrix[1] == state[1] &&
          matrix[2] == state[2]
      end

      false
    end

    # Public: tells which moves will bring about a new result
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
    def useful_moves
      result = {}

      possible_moves.each do |direction|
        matrix = game.try_move(direction)
        next if been_to?(matrix)

        md_ary = md_array(matrix)
        md = manhattan_distance(md_ary)
        result[direction] = md
      end

      result
    end

    def move(direction)
      raise "Cannot move that direction" unless game.can_move?(direction)

      moves << direction
      state = game.move(direction)
      add_state(state)

      state
    end

    def possible_moves
      game.possible_moves
    end

    def next_direction
      moves = useful_moves
      raise Exception.new("No more useful moves") if moves.empty?
      moves.sort_by {|k,v| v }.first[0]
    end

    def next_move
      move(next_direction)
    end

    def solve(options={})
      begin
        while current_state != GOAL_ARRAY
          move = next_move
          if options[:debug]
            puts move.inspect
            puts manhattan_distance(current_state)
          end
        end
      rescue Exception
        puts "no more useful moves"
        puts "current state: #{current_state.inspect}"
        puts "manhattan distance: #{manhattan_distance(current_state)}"
      end
    end
  end
end
