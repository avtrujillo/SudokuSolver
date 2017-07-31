# from http://rubyquiz.com/quiz43.html

Dir.chdir(__dir__)

require 'byebug'
require 'set'

require_relative './objects/tile'
require_relative './objects/mustcontain'
require_relative './objects/ninegroups/ninegroup'
require_relative './objects/ninegroups/innersquare'
require_relative './objects/ninegroups/column'
require_relative './objects/ninegroups/row'
require_relative './objects/board/importboard'
require_relative './objects/board/solution'
require_relative './objects/board/board'

Board.create_board_from_input.solve
