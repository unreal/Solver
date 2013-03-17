module SlidingPuzzle

  # Methods useful for both the Game and Solver
  module CommonMethods
    # Public: Find where a number is within a target matrix
    #
    # num - the number to search for
    # target - an array to search through
    #
    # Examples
    #
    #   location(5, some_array)
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
  end
end
