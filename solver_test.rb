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
    assert_equal 0, Solver.new(Solver::GOAL_ARRAY).manhattan_distance
  end

  test "md array" do
    assert_equal [
      [2, 1, 0],
      [2, 1, 1],
      [2, 2, 1]
    ], @solver.md_array

    assert_equal [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ], Solver.new(Solver::GOAL_ARRAY).md_array
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
    assert_equal [2,1], @solver.location(4, :start)
    assert_equal [1,0], @solver.location(4, :goal)
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

  test "can move method" do
    assert @solver.can_move?(:left)
    assert !@solver.can_move?(:right)
    assert @solver.can_move?(:up)
    assert @solver.can_move?(:down)
  end

  test "target_location method" do
    assert_equal [0, 1], @solver.target_location([1, 1], :up)
    assert_equal [2, 1], @solver.target_location([1, 1], :down)
    assert_equal [1, 0], @solver.target_location([1, 1], :left)
    assert_equal [1, 2], @solver.target_location([1, 1], :right)
  end

  test "move method" do
    @solver.move(:up)
    assert_equal [
      [7,5,0],
      [2,8,3],
      [1,4,6]
    ], @solver.start_array

    @solver.move(:left)
    assert_equal [
      [7,0,5],
      [2,8,3],
      [1,4,6]
    ], @solver.start_array

    @solver.move(:down)
    assert_equal [
      [7,8,5],
      [2,0,3],
      [1,4,6]
    ], @solver.start_array

    @solver.move(:right)
    assert_equal [
      [7,8,5],
      [2,3,0],
      [1,4,6]
    ], @solver.start_array
  end

  test "try_move method" do
    assert_equal [
      [7, 5, 0],
      [2, 8, 3],
      [1, 4, 6]
    ], @solver.try_move(:up)

    assert_nil @solver.try_move(:right)
  end

end
