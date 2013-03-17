require 'test_helper'

class SolverTest < Test::Unit::TestCase
  include SlidingPuzzle

  def setup
    @game = Game.new(
      [
        [7, 5, 3],
        [2, 8, 0],
        [1, 4, 6]
      ]
    )
    @solver = Solver.new(@game)
  end

  test "the solver has a goal array" do
    assert_equal [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 0]
    ], Solver::GOAL_ARRAY
  end

  test "game" do
    assert_equal @game, @solver.game
  end

  test "manhattan distance" do
    assert_equal 12, @solver.manhattan_distance(@solver.game.start_state)
    assert_equal 0,  @solver.manhattan_distance(Solver::GOAL_ARRAY)
  end

  test "manhattan distance array" do
    assert_equal [
      [2, 1, 0],
      [2, 1, 1],
      [2, 2, 1]
    ], @solver.md_array(@solver.game.start_state)

    assert_equal [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ], @solver.md_array(Solver::GOAL_ARRAY)
  end

  test "distance" do
    assert_equal 1, @solver.distance(0, @solver.game.start_state)
    assert_equal 2, @solver.distance(1, @solver.game.start_state)
    assert_equal 2, @solver.distance(2, @solver.game.start_state)
    assert_equal 0, @solver.distance(3, @solver.game.start_state)
    assert_equal 2, @solver.distance(4, @solver.game.start_state)
    assert_equal 1, @solver.distance(5, @solver.game.start_state)
    assert_equal 1, @solver.distance(6, @solver.game.start_state)
    assert_equal 2, @solver.distance(7, @solver.game.start_state)
    assert_equal 1, @solver.distance(8, @solver.game.start_state)
  end

  test "location method" do
    assert_equal [2,1], @solver.location(4, @solver.game.start_state)
    assert_equal [1,0], @solver.location(4, Solver::GOAL_ARRAY)
  end

  test "distance away" do
    assert_equal 2, @solver.distance_away([2,1], [1,0])
  end

  test "useful_moves method" do
    result = @solver.useful_moves
    assert_equal 9, result[:up]
    assert_equal 12, result[:down]
    assert_equal 10, result[:left]
  end

  test "useful_moves moves does not affect current state" do
    state = @game.current_state

    @solver.useful_moves
    @solver.useful_moves

    assert_equal state, @game.current_state
    assert_equal state, @solver.current_state
  end

  test "move" do
    @solver.move(:up)
    assert_equal [:up], @solver.moves
    assert_equal :up, @solver.last_move
    assert_equal [
      [7, 5, 0],
      [2, 8, 3],
      [1, 4, 6]
    ], @solver.game.current_state
    assert @solver.previous_states.include?(
      [
        [7, 5, 0],
        [2, 8, 3],
        [1, 4, 6]
      ]
    )
    assert_equal 2, @solver.previous_states.length
  end

  test "previous states" do
    assert_equal [@solver.game.current_state], @solver.previous_states
  end

  test "moves" do
    assert_equal [], @solver.moves
  end

  test "useful_moves does not include a move that would put us into a previous state" do
    @solver.move(:up)

    assert_equal [:left], @solver.useful_moves.keys
  end

  test "next_direction" do
    assert_equal :up, @solver.next_direction
  end

  test "next direction does not effect state" do
    state = @solver.current_state

    @solver.next_direction

    assert_equal state, @solver.current_state
    assert_equal state, @solver.game.current_state
  end

  test "current_state" do
    assert_equal @game.current_state, @solver.current_state
  end

  test "been_to" do
    matrix = [[],[],[]]
    matrix[0] = @solver.current_state[0].dup
    matrix[1] = @solver.current_state[1].dup
    matrix[2] = @solver.current_state[2].dup

    assert @solver.been_to?(matrix)
  end

  test "next_move" do
    assert_equal [
      [7, 5, 0],
      [2, 8, 3],
      [1, 4, 6]
    ], @solver.next_move

    assert_equal [
      [7, 0, 5],
      [2, 8, 3],
      [1, 4, 6]
    ], @solver.next_move

    assert_equal [
      [0, 7, 5],
      [2, 8, 3],
      [1, 4, 6]
    ], @solver.next_move
  end

  test "solve" do
    @solver.solve(debug: true)
    assert_equal Solver::GOAL_ARRAY, @solver.current_state
  end

end

