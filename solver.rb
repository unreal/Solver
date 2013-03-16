require 'rubygems'

class Solver

  attr_reader :goalRow1, :goalRow2, :goalRow3
  attr_reader :row1, :row2, :row3

  def initialize(row1, row2, row3)
    @goalRow1 = [1,2,3]
    @goalRow2 = [4,5,6]
    @goalRow3 = [7,8,0]

    @row1 = row1
    @row2 = row2
    @row3 = row3
  end

  def goalArray
    [@goalRow1, @goalRow2, @goalRow3]
  end

  def startArray
    [@row1, @row2, @row3]
  end

  def md
    sum = 0
    startArray.flatten.each do |v|
      sum += distance(v)
    end

    sum
  end

  def mdArray
    [[2,1,0], [2,1,1], [2,2,1]]
  end

  def distance(num)
    locationGoal = location(num, goalArray)
    locationStart = location(num, startArray)
    distanceAway(locationGoal, locationStart)

  end

  def location(num, targetArray)
    targetArray.each_index do |row_index|
      targetArray[row_index].each_index do |col|
        return [row_index, col] if targetArray[row_index][col] == num
      end
    end
  end

  def distanceAway(goalarr, startarr)
    (startarr[0] - goalarr[0]).abs + (startarr[1] - goalarr[1]).abs
  end

  def can_move_left?
    location(0, startArray)[1] > 0
  end

  def can_move_right?
    location(0, startArray)[1] < 2
  end

  def can_move_up?
    location(0, startArray)[0] > 0
  end

  def can_move_down?
    location(0, startArray)[0] < 2
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


