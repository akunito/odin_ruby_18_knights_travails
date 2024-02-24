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

    @vertices = Array.new(@x_max) { |_i| Array.new(@y_max) { |_i| 0 }}

    puts "\n========== generating nodes ============="
    generate_nodes


    # puts "\n========== testing ============="
    # puts "[#{@vertices[0][0].x__},#{@vertices[0][0].y__}]"
    # puts "[#{@vertices[1][0].x__},#{@vertices[1][0].y__}]"
    #
    # puts "[#{@vertices[1][1].x__},#{@vertices[1][1].y__}]"
  end

  def generate_nodes
    y = @y_max-1
    @y_max.times do
      x = 0
      @x_max.times do
        # puts "#{x}, #{y}"
        @vertices[x][y] = Vertex.new(x, y)
        x += 1
      end
      y -= 1
    end
  end

  def print_header
    puts "\n"
    header = "  |"
    @x_max.times { |x| header << "  #{x}  |" }
    puts header
  end

  def print_footer
    puts "  |#{'-----|'*@x_max}\n"
  end

  def print
    print_header

    @vertices.each_with_index do |row, y|
      concat = "#{y} |"
      puts "  |#{'-----|'*@x_max}"
      row.each do |cell|
        concat << " #{cell.x__},#{cell.y__} |" # to test indexes
        # concat << "  #{cell.status}  |"
      end
      puts concat
    end

    print_footer
  end

  def knight_moves(to_x, to_y)

  end
end

chess_board = Board.new(8,8)

chess_board.print

chess_board.knight_moves()