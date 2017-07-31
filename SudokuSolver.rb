# from http://rubyquiz.com/quiz43.html

require 'byebug'
require 'set'

require_relative './tile'
require_relative './mustcontain'
require_relative './ninegroup'
require_relative './innersquare'
require_relative './column'
require_relative './row'
require_relative './importboard'
require_relative './solution'
require_relative './board'

Board.create_board_from_input.solve
