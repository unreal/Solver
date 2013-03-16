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

  def md
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
    location_goal = location(num, GOAL_ARRAY)
    location_start = location(num, start_array)

    distance_away(location_goal, location_start)
  end

  def location(num, target_array)
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
    arr.push(:left) if can_move_left?
    arr.push(:right) if can_move_right?
    arr.push(:down) if can_move_down?
    arr.push(:up) if can_move_up?
    arr.sort
  end
end
