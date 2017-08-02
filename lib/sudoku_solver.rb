Dir.chdir(__dir__)

require 'set'

require_relative './sudoku_solver/tile'
require_relative './sudoku_solver/mustcontain'
require_relative './sudoku_solver/ninegroups/ninegroup'
require_relative './sudoku_solver/ninegroups/innersquare'
require_relative './sudoku_solver/ninegroups/column'
require_relative './sudoku_solver/ninegroups/row'
require_relative './sudoku_solver/board/importboard'
require_relative './sudoku_solver/board/solution'
require_relative './sudoku_solver/board/board'

Board.create_board_from_input.solve
