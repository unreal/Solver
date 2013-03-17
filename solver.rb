require 'rubygems'

class Solver

  attr_accessor :last_move
  attr_reader :start_array

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

  def initialize(start_array)
    @start_array = start_array
    @last_move = nil
  end

  # This is from a discussion thread here:
  # https://www.allegro.cc/forums/thread/307339
  def manhattan_distance(target=start_array)
    sum = 0
    target.flatten.each do |v|
      sum += distance(v, target)
    end

    sum
  end

  # Public: Returns the manhattan distance array for a given array
  #
  # target_array - default: start_array
  #                can figure out the md_array for another
  def md_array(target=start_array)
    md_array = [[],[],[]]

    target.each_index do |row_index|
      target[row_index].each_index do |col_index|
        md_array[row_index][col_index] =
          distance(target[row_index][col_index], target)
      end
    end

    md_array
  end

  def distance(num,start_array)
    location_goal = location(num, Solver::GOAL_ARRAY)
    location_start = location(num,start_array)

    distance_away(location_goal, location_start)
  end

  # Public: Find where a number is within a target matrix
  #
  # num - the number to search for
  # target - either :start or :goal to specify which array to look in
  #
  # Examples
  #
  #   location(5, :start)
  #   # => [1, 0]
  #
  # Returns the location in [row, col] format
  def location(num, target)
    target.each_index do |row_index|
      target[row_index].each_index do |col|
        return [row_index, col] if target[row_index][col] == num
      end
    end
  end

  # Locations are given as [row,col] from #location
  def distance_away(start_location, end_location)
    (start_location[0] - end_location[0]).abs +
      (start_location[1] - end_location[1]).abs
  end

  def can_move_left?
    location(0, start_array)[1] > 0
  end

  def can_move_right?
    location(0, start_array)[1] < 2
  end

  def can_move_up?
    location(0, start_array)[0] > 0
  end

  def can_move_down?
    location(0, start_array)[0] < 2
  end

  def possible_moves
    arr = []
    arr.push(:left)  if can_move_left?
    arr.push(:right) if can_move_right?
    arr.push(:down)  if can_move_down?
    arr.push(:up)    if can_move_up?
    arr.sort
  end

  def can_move?(direction)
    send("can_move_#{direction}?")
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

    start_location = location(0, start_array)
    target_location = target_location(start_location, direction)

    target_value = start_array[target_location[0]][target_location[1]]

    new_array = start_array
    new_array[start_location[0]][start_location[1]] = target_value
    new_array[target_location[0]][target_location[1]] = 0

    new_array
  end

  # Public: Makes the move and changes start_array
  def move(direction)
    raise "Cannot move #{direction}." unless can_move?(direction)

    @last_move = direction
    start_array = try_move(direction)
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

    possible_moves.each do |direction|
      matrix = try_move(direction)
      md_ary = md_array(matrix)
      md = manhattan_distance(md_ary)
      result[direction] = md
    end

    result
  end

end
