require 'test_helper'

class GameTest < Test::Unit::TestCase
  include SlidingPuzzle

  def setup
    @game = Game.new(
      [
        [7, 5, 3],
        [2, 8, 0],
        [1, 4, 6]
      ]
    )
  end

  test "start condition" do
    assert_equal [
      [7, 5, 3],
      [2, 8, 0],
      [1, 4, 6]
    ], @game.start_state
  end

  test "can move left" do
    assert @game.can_move_left?
    @game= Game.new([[0,5,3],[2,8,7], [1,4,6]])
    assert !@game.can_move_left?
  end

  test "can move right" do
    assert !@game.can_move_right?
    @game = Game.new([[0,5,3],[2,8,7], [1,4,6]])
    assert @game.can_move_right?
  end

  test "can move up" do
    assert @game.can_move_up?
    @game = Game.new([[0,5,3],[2,8,7], [1,4,6]])
    assert !@game.can_move_up?
  end

  test "can move down" do
    assert @game.can_move_down?
    @game = Game.new([[4,5,3],[2,8,7], [1,0,6]])
    assert !@game.can_move_down?
  end

  test "current state possible moves" do
    assert_equal [:down, :left, :up], @game.possible_moves
  end

  test "target_location method" do
    assert_equal [0, 1], @game.target_location([1, 1], :up)
    assert_equal [2, 1], @game.target_location([1, 1], :down)
    assert_equal [1, 0], @game.target_location([1, 1], :left)
    assert_equal [1, 2], @game.target_location([1, 1], :right)
  end

  test "can_move?" do
    assert  @game.can_move?(:left)
    assert !@game.can_move?(:right)
    assert  @game.can_move?(:up)
    assert  @game.can_move?(:down)
  end

  test "move down" do
    assert_equal [
      [7, 5, 3],
      [2, 8, 6],
      [1, 4, 0]
    ], @game.move(:down)

    assert_raise(Exception) { @game.move(:down) }
  end

  test "move" do
    @game.move(:up)
    assert_equal [
      [7, 5, 0],
      [2, 8, 3],
      [1, 4, 6]
    ], @game.current_state

    @game.move(:left)
    assert_equal [
      [7, 0, 5],
      [2, 8, 3],
      [1, 4, 6]
    ], @game.current_state


    @game.move(:down)
    assert_equal [
      [7,8,5],
      [2,0,3],
      [1,4,6]
    ], @game.current_state

    @game.move(:down)
    assert_equal [
      [7,8,5],
      [2,4,3],
      [1,0,6]
    ], @game.current_state

    @game.move(:right)
    assert_equal [
      [7,8,5],
      [2,4,3],
      [1,6,0]
    ], @game.current_state
  end

  test "try_move method" do
    assert_equal [
      [7, 5, 0],
      [2, 8, 3],
      [1, 4, 6]
    ], @game.try_move(:up)

    assert_nil @game.try_move(:right)
  end

  test "try move does not affect current_state" do
    state = @game.current_state

    @game.try_move(:up)
    @game.try_move(:up)

    assert_equal state, @game.current_state
  end

  test "try move does not affect possible_moves" do
    assert_equal [:down,:left,:up], @game.possible_moves

    @game.try_move(:up)

    assert_equal [:down,:left,:up], @game.possible_moves
  end

end
