# https://www.theodinproject.com/lessons/ruby-knights-travails

@debug = true

def log(string)
  puts string if @debug
end

class Vertex
  attr_reader :x__, :y__, :status

  def initialize(x__, y__)
    return unless x__ >= 0 && y__ >= 0

    @x__ = x__
    @y__ = y__
    @status = " "
  end
end

class Board
  attr_reader :x_max, :y_max

  def initialize(x_max, y_max)
    return unless x_max.positive? && y_max.positive?

    @x_max = x_max
    @y_max = y_max

    @chips = {
      # White back
      "WT0" => "♜", "WH1" => "♞", "WB2" => "♝", "WQ3" => "♛", "WK4" => "♚", "WB5" => "♝", "WH6" => "♞", "WT7" => "♜",

      # White pawns
      "WP0" => "♟", "WP1" => "♟", "WP2" => "♟", "WP3" => "♟", "WP4" => "♟", "WP5" => "♟", "WP6" => "♟", "WP7" => "♟",

      # Black back
      "BT0" => "♖", "BH1" => "♘", "BB2" => "♗", "BQ3" => "♕", "BK4" => "♔", "BB5" => "♗", "BH6" => "♘", "BT7" => "♖",

      # Black pawns
      "BP0" => "♙", "BP1" => "♙", "BP2" => "♙", "BP3" => "♙", "BP4" => "♙", "BP5" => "♙", "BP6" => "♙", "BP7" => "♙",
    }

    @chips.each {|c| p c }

    @vertices = Array.new(@x_max) {|_i| Array.new(@y_max) {|_i| 0 } }

    generate_nodes

    # puts "\n========== testing ============="
    # puts "[#{@vertices[0][0].x__},#{@vertices[0][0].y__}]"
    # puts "[#{@vertices[1][0].x__},#{@vertices[1][0].y__}]"
    #
    # puts "[#{@vertices[1][1].x__},#{@vertices[1][1].y__}]"
  end

  def generate_nodes
    @y_max.times.reverse_each do |y|
      @x_max.times {|x| @vertices[x][y] = Vertex.new(x, y) }
    end
  end

  def print_header
    puts "\n"
    header = "  |"
    @x_max.times {|x| header << "  #{x}  |" }
    puts header
  end

  def print_footer
    puts "  |#{'-----|'*@x_max}\n"
  end

  def print
    print_header

    @vertices.each_with_index.reverse_each do |row, y|
      concat = "#{y} |"
      puts "  |#{'-----|'*@x_max}"
      row.each {|cell| concat << "  #{cell.status}  |" }
      # row.each { |cell| concat << " #{cell.x__},#{cell.y__} |" } # to test indexes
      puts concat
    end

    print_footer
  end

  def search_horse(chip)

  end

  def set_position(x_pos, y_pos, chip)
    if chip == "horse"
      search_horse(chip)
    end
  end

  def knight_moves(to_x, to_y)

  end
end

chess_board = Board.new(8,8)

chess_board.print

chess_board.set_position(3,4, "horse")

# chess_board.knight_moves()
