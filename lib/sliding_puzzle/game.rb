module SlidingPuzzle
  class Game

    include CommonMethods

    attr_reader :start_state, :current_state

    def initialize(start_state)
      @start_state = @current_state = start_state
    end

    def can_move_left?
      location(0, current_state)[1] > 0
    end

    def can_move_right?
      location(0, current_state)[1] < 2
    end

    def can_move_up?
      location(0, current_state)[0] > 0
    end

    def can_move_down?
      location(0, current_state)[0] < 2
    end

    def can_move?(direction)
      send("can_move_#{direction}?")
    end

    def possible_moves
      arr = []
      arr.push(:left)  if can_move_left?
      arr.push(:right) if can_move_right?
      arr.push(:down)  if can_move_down?
      arr.push(:up)    if can_move_up?
      arr.sort
    end

    def target_location(start_location, direction)
      case direction
      when :up
        [start_location[0] - 1, start_location[1]]
      when :down
        [start_location[0] + 1, start_location[1]]
      when :left
        [start_location[0], start_location[1] - 1]
      when :right
        [start_location[0], start_location[1] + 1]
      else
        raise "Invalid direction"
      end
    end

    # Public: Attempts to move the 0 in some direction from its current position
    # within the start_array
    #
    # direction - can be :up, :down, :left or :right
    #
    # Examples:
    #
    #   @solver.try_move(:up)
    #   # => [
    #     [7, 5, 0],
    #     [2, 8, 3],
    #     [1, 4, 6]
    #   ]
    #
    #   @solver.try_move(:right)
    #   # => nil
    #
    # Returns the result of the move if the move is possible or nil if impossible
    def try_move(direction)
      return nil unless can_move?(direction)

      start_location = location(0, current_state)
      target_location = target_location(start_location, direction)

      target_value = current_state[target_location[0]][target_location[1]]

      new_array = current_state
      new_array[start_location[0]][start_location[1]] = target_value
      new_array[target_location[0]][target_location[1]] = 0

      new_array
    end

    # Public: Makes the move and changes current_state
    def move(direction)
      raise "Cannot move #{direction}." unless can_move?(direction)

      current_state = try_move(direction)
    end
  end
end
