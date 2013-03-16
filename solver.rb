require 'rubygems'

class Solver

  attr_reader :start_array

  GOAL_ARRAY = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 0]
  ]

  def initialize(start_array)
    @start_array = start_array
  end

  def manhattan_distance
    sum = 0
    start_array.flatten.each do |v|
      sum += distance(v)
    end

    sum
  end

  def md_array
    [[2,1,0], [2,1,1], [2,2,1]]
  end

  def distance(num)
    location_goal = location(num, :goal)
    location_start = location(num, :start)

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
    if target == :start
      target_array = @start_array
    else
      target_array = GOAL_ARRAY
    end

    target_array.each_index do |row_index|
      target_array[row_index].each_index do |col|
        return [row_index, col] if target_array[row_index][col] == num
      end
    end
  end

  # Locations are given as [row,col] from #location
  def distance_away(start_location, end_location)
    (start_location[0] - end_location[0]).abs + (start_location[1] - end_location[1]).abs
  end

  def can_move_left?
    location(0, :start)[1] > 0
  end

  def can_move_right?
    location(0, :start)[1] < 2
  end

  def can_move_up?
    location(0, :start)[0] > 0
  end

  def can_move_down?
    location(0, :start)[0] < 2
  end

  def possible_moves
    arr = []
    arr.push(:left) if can_move_left?
    arr.push(:right) if can_move_right?
    arr.push(:down) if can_move_down?
    arr.push(:up) if can_move_up?
    arr.sort
  end
end
