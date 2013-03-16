require 'rubygems'
require 'test-unit'
require './solver'

class SolverTest < Test::Unit::TestCase

  def setup
    @solver = Solver.new([[7,5,3],[2,8,0], [1,4,6]])
  end

  test "the solver has a goal array" do
    assert_equal [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 0]
    ], Solver::GOAL_ARRAY
  end

  test "start array" do 
    assert_equal [
      [7, 5, 3],
      [2, 8, 0],
      [1, 4, 6]
    ], @solver.start_array
  end

  test "manhattan distance" do
    assert_equal 12, @solver.manhattan_distance
  end

  test "md array" do
    assert_equal [[2,1,0], [2,1,1], [2,2,1]], @solver.md_array
  end

  test "number distance" do
    assert_equal 1, @solver.distance(0)
    assert_equal 2, @solver.distance(1)
    assert_equal 2, @solver.distance(2)
    assert_equal 0, @solver.distance(3)
    assert_equal 2, @solver.distance(4)
    assert_equal 1, @solver.distance(5)
    assert_equal 1, @solver.distance(6)
    assert_equal 2, @solver.distance(7)
    assert_equal 1, @solver.distance(8)
  end

  test "location method" do
    assert_equal [2,1], @solver.location(4, @solver.start_array)
    assert_equal [1,0], @solver.location(4, Solver::GOAL_ARRAY)
  end

  test "distance away" do 
    assert_equal 2, @solver.distance_away([2,1], [1,0])
  end

  test "can move left" do
    assert @solver.can_move_left?
    @solver = Solver.new([[0,5,3],[2,8,7], [1,4,6]])
    assert !@solver.can_move_left?
  end

  test "can move right" do
    assert !@solver.can_move_right?
    @solver = Solver.new([[0,5,3],[2,8,7], [1,4,6]])
    assert @solver.can_move_right?
  end

  test "can move up" do
    assert @solver.can_move_up?
    @solver = Solver.new([[0,5,3],[2,8,7], [1,4,6]])
    assert !@solver.can_move_up?
  end

  test "can move down" do
    assert @solver.can_move_down?
    @solver = Solver.new([[4,5,3],[2,8,7], [1,0,6]])
    assert !@solver.can_move_down?
  end

  test "current state possible moves" do
    assert_equal [:down, :left, :up], @solver.possible_moves
  end

end
