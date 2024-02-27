# https://www.theodinproject.com/lessons/ruby-knights-travails

# require_relative "./tree"

@debug = true

def log(string)
  puts string if @debug
end

class Vertex
  attr_reader :x__, :y__
  attr_accessor :status, :background, :temp_status, :links

  def initialize(x__, y__)
    return unless x__ >= 0 && y__ >= 0

    @x__ = x__
    @y__ = y__
    @status = " "
    @background = " "
    @temp_status = " "

    @links = []
  end
end

class Tree
  attr_accessor :root

  def initialize(vertices, current_x, current_y, x_to, y_to, type_of_movements)
    puts "====================== initialize tree ================================"
    @vertices_queue = vertices

    # print all vertices x y
    # @vertices_queue.each do |vertex|
    #   puts "#{vertex.x__}, #{vertex.y__}"
    # end

    @root = build_tree(current_x, current_y, x_to, y_to, type_of_movements)
  end

  def next_positions(current_x, current_y, chip_movements)
    # Use this one for calculate paths closer to given destiny for Knights Travails project
    return unless current_x.between?(0,7) && current_y.between?(0,7)

    possible_movements = []
    chip_movements.each do |movement|
      next unless (current_x + movement[0]).between?(0,7) && (current_y + movement[1]).between?(0,7)

      temp_array = [],[]
      temp_array[0] = (current_x + movement[0])
      temp_array[1] = (current_y + movement[1])
      possible_movements << temp_array
    end
    # possible_movements.each { |movement| p movement }

    # print_only_temp_positions(possible_movements)

    possible_movements
  end

  def link_next_positions(current_positions, current_root)
    # get the new positions (current_positions in this scope) and link them to current_root
    next_positions = []

    current_positions.each do |position|
      next_positions << find_vertex(position[0], position[1])  # HERE SOMETHING IS LINKING MORE THAN IT SHOULD
    end

    # link the next positions found to current root
    current_root.links = next_positions

    next_positions
  end

  def find_vertex(current_x, current_y)
    @vertices_queue.each do |vertex|
      next unless (vertex.x__ == current_x) && (vertex.y__ == current_y)

      return vertex
    end
  end

  def delete_vertex(current_x, current_y)
    @vertices_queue.each_with_index do |vertex, i|
      next unless (vertex.x__ == current_x) && (vertex.y__ == current_y)

      puts "deleting next"
      p @vertices_queue.delete_at(i)
    end
  end

  def build_tree(current_x, current_y, x_to, y_to, type_of_movements)
    return unless @vertices_queue.length.positive?

    # get root and delete it from @vertices_queue
    root = find_vertex(current_x, current_y)
    delete_vertex(root.x__, root.y__)

    # get next positions
    next_positions = next_positions(root.x__, root.y__, type_of_movements)
    # link positions to root
    next_positions = link_next_positions(next_positions, root)
    # delete linked positions from @vertices_queue
    next_positions.each { |vertex| delete_vertex(vertex.x__, vertex.y__) }
    # iterate next_positions
    next_root = next_positions

    trash_bin = []
    next_root.each do |next_root_|
      # get next positions
      next_positions = next_positions(next_root_.x__, next_root_.y__, type_of_movements)
      # link positions to root
      next_positions = link_next_positions(next_positions, next_root_)
      # gather all the used positions to remove later
      puts "\n"
      next_positions.each { |position| p position }
      # next_positions.each { |position| trash_bin << position }
    end

    puts "\ntrash bin ======="
    trash_bin.each do |vertex|
      p vertex
      # delete_vertex(vertex.x__, vertex.y__)
    end

    root
  end
end


class Board
  attr_reader :x_max, :y_max

  def initialize(x_max, y_max)
    return unless x_max.positive? && y_max.positive?

    @x_max = x_max
    @y_max = y_max

    @chips = {
      # White back >>>  Tower Left | Horse Left | Bishop Left |Queen | King | Right side...
      WTL: "♜", WHL: "♞", WBL: "♝", WQ: "♛", WK: "♚", WBR: "♝", WHR: "♞", WTR: "♜",

      # White pawns
      WP0: "♟", WP1: "♟", WP2: "♟", WP3: "♟", WP4: "♟", WP5: "♟", WP6: "♟", WP7: "♟",

      # Black back
      BTR: "♖", BHR: "♘", BBR: "♗", BQ: "♕", BK: "♔", BBL: "♗", BHL: "♘", BTL: "♖",

      # Black pawns
      BP0: "♙", BP1: "♙", BP2: "♙", BP3: "♙", BP4: "♙", BP5: "♙", BP6: "♙", BP7: "♙",
    }

    @horse_movements =
      [+2, +1],
      [+2, -1],
      [+1, -2],
      [-1, -2],
      [-2, -1],
      [-2, +1],
      [-1, +2],
      [+1, +2]

    @chips.each {|c| p c }

    @vertices = Array.new(@x_max) {|_i| Array.new(@y_max) {|_i| 0 } }

    generate_nodes

    paint_chess

    # puts "\n========== testing ============="
    # puts "[#{@vertices[0][0].x__},#{@vertices[0][0].y__}]"
    # puts "[#{@vertices[1][0].x__},#{@vertices[1][0].y__}]"
    #
    # puts "[#{@vertices[1][1].x__},#{@vertices[1][1].y__}]"
  end

  def generate_nodes
    (@y_max-1).downto(0).each do |y|
      @x_max.times {|x| @vertices[x][y] = Vertex.new(x, y) }
    end
  end

  def paint_chess
    (@y_max-1).downto(0).each do |y|
      @vertices[y].each_with_index do |cell, x|
        cell.background = if y.even?
                            # (x.even? ? "⬜" : "⬛") # testing different chars
                            (x.even? ? " " : " ")
                          else
                            # (x.even? ? "⬛" : "⬜") # testing different chars
                            (x.even? ? " " : " ")
                          end
      end
    end
    # @vertices.each { |row| row.each { |cell| cell.status = cell.background } }
  end

  def print_header
    header = "\n  |"
    # @x_max.times {|x| header << "#{x}|" }
    # header << "0️|1️2️3️|4️|5️6️|7️" # testing different chars
    header << "0|1|2|3|4|5|6|7|"
    puts header
  end

  def print
    print_header

    (@y_max-1).downto(0).each do |y|
      concat = "#{y} |"
      @vertices[y].each do |cell|
        concat << if cell.status == " " # if cell is empty -> show background or temp position O
                    cell.temp_status == " " ? "#{cell.background}|" : "#{cell.temp_status}|"
                  else                  # if cell is busy ->  show status or temp position X
                    cell.temp_status == " " ? "#{@chips[cell.status]}|" : "X|"
                  end
      end
      puts concat
    end

    puts "\n"
  end

  def print_only_temps
    print_header

    (@y_max-1).downto(0).each do |y|
      concat = "#{y} |"
      @vertices[y].each do |cell|
        concat << (cell.temp_status == " " ? "#{cell.background}|" : "#{cell.temp_status}|")
      end
      puts concat
    end

    puts "\n"
  end

  def search_chip(chip)
    @vertices.each { |row| row.each { |cell| return cell if cell.status == chip } }
    nil
  end

  def set_first_position(x_pos, y_pos, chip)
    return unless @chips[chip] && x_pos.between?(0,7) && y_pos.between?(0,7)

    @vertices[y_pos][x_pos].status = chip # @chips[chip]
    "#{chip} #{@vertices[y_pos][x_pos].status} have been set"
  end

  def print_temp_positions(possible_movements)
    # setting temp positions
    possible_movements.each do |movement|
      @vertices[movement[0]][movement[1]].temp_status = "O"
      # puts "Temp position #{movement} -> #{@vertices[movement[0]][movement[1]].temp_status} have been set"
    end

    # printing temp positions
    print

    # removing temp positions
    possible_movements.each do |movement|
      @vertices[movement[0]][movement[1]].temp_status = " "
      # puts "Temp position #{movement} -> #{@vertices[movement[0]][movement[1]].temp_status} have been removed"
    end
  end

  def print_only_temp_positions(possible_movements)
    # setting temp positions
    possible_movements.each do |movement|
      @vertices[movement[0]][movement[1]].temp_status = "O"
      # puts "Temp position #{movement} -> #{@vertices[movement[0]][movement[1]].temp_status} have been set"
    end

    # printing temp positions
    print_only_temps

    # removing temp positions
    possible_movements.each do |movement|
      @vertices[movement[0]][movement[1]].temp_status = " "
      # puts "Temp position #{movement} -> #{@vertices[movement[0]][movement[1]].temp_status} have been removed"
    end
  end

  def set_chess_new_match_positions
    # White
    set_first_position(0,0,:WTL)
    set_first_position(1,0,:WHL)
    set_first_position(2,0,:WBL)
    set_first_position(3,0,:WK)
    set_first_position(4,0,:WQ)
    set_first_position(5,0,:WBR)
    set_first_position(6,0,:WHR)
    set_first_position(7,0,:WTR)

    set_first_position(0,1,:WP0)
    set_first_position(1,1,:WP1)
    set_first_position(2,1,:WP2)
    set_first_position(3,1,:WP3)
    set_first_position(4,1,:WP4)
    set_first_position(5,1,:WP5)
    set_first_position(6,1,:WP6)
    set_first_position(7,1,:WP7)

    # Black
    set_first_position(0,7,:BTR)
    set_first_position(1,7,:BHR)
    set_first_position(2,7,:BBR)
    set_first_position(3,7,:BQ)
    set_first_position(4,7,:BK)
    set_first_position(5,7,:BBL)
    set_first_position(6,7,:BHL)
    set_first_position(7,7,:BTL)

    set_first_position(0,6,:BP0)
    set_first_position(1,6,:BP1)
    set_first_position(2,6,:BP2)
    set_first_position(3,6,:BP3)
    set_first_position(4,6,:BP4)
    set_first_position(5,6,:BP5)
    set_first_position(6,6,:BP6)
    set_first_position(7,6,:BP7)
  end

  def set_possible_movements_temp(possible_movements, chip)
    possible_movements.each { |movement| set_first_position(movement[0], movement[1], chip, true) }
  end

  def get_possible_movements(chip, chip_movements)
    # Use this one for chess game
    return puts "\nthat chip is out of the board" unless search_chip(chip)

    current_pos = search_chip(chip)
    possible_movements = []
    chip_movements.each do |movement|
      next unless (current_pos.x__ + movement[0]).between?(0,7) && (current_pos.y__ + movement[1]).between?(0,7)

      temp_array = [],[]
      temp_array[0] = (current_pos.x__ + movement[0])
      temp_array[1] = (current_pos.y__ + movement[1])
      possible_movements << temp_array
    end

    possible_movements.each { |movement| p movement }

    print_temp_positions(possible_movements)

    possible_movements
  end

  def return_all_vertices
    cells = []
    (@y_max-1).downto(0).each do |y|
      @x_max.times {|x| cells << @vertices[x][y] }
    end
    cells
  end

  def check_moves_knight(chip)
    get_possible_movements(chip, @horse_movements)
  end

  def get_possible_path(current_x, current_y, x_to, y_to, type_of_movements)
    # set type_of_movements with for example: @horse_movements
    puts "============================ GET POSSIBLE PATH ================================="

    # create Tree and build it up
    tree = Tree.new(return_all_vertices, current_x, current_y, x_to, y_to, type_of_movements)

    puts "\n\nreturning result >>>"
    p tree
  end

  def get_horse_paths(x_from, y_from, x_to, y_to)
    puts "============================================ get horse paths test ===================================="
    get_possible_path(x_from, y_from, x_to, y_to, @horse_movements)
  end

  def check_moves(chip)
    # horses
    case
    when chip.to_s.include?("T")
      puts "towers"
    when chip.to_s.include?("H")
      puts "horses"
      check_moves_knight(chip)
    when chip.to_s.include?("B")
      puts "bishops"
    when chip.to_s.include?("Q")
      puts "queen"
    when chip.to_s.include?("K")
      puts "king"
    when chip.to_s.include?("P")
      puts "pawns"
    else
      puts "chip's moves not set yet"
    end
  end
end

chess_board = Board.new(8,8)

chess_board.print

p chess_board.set_first_position(0,4, :WHL)
p chess_board.set_first_position(2,5, :BHL)

chess_board.print

# chess_board.check_moves(:WHL)
chess_board.check_moves(:WHL)

chess_board.get_horse_paths(0, 4, 7, 7)

# chess_board.set_chess_new_match_positions

# chess_board.print