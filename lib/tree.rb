class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Vertex
  attr_reader :x__, :y__
  attr_accessor :status, :background, :temp_status

  def initialize(x__, y__)
    return unless x__ >= 0 && y__ >= 0

    @x__ = x__
    @y__ = y__
    @status = " "
    @background = " "
    @temp_status = " "
  end
end

class Tree
  attr_accessor :root, :left, :right, :data

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array)
    return unless array.length.positive?

    # find middle index
    mid = array.length/2

    # make the middle element the root
    root = Node.new(array[mid])

    # left subtree of root has all values < mid
    root.left = build_tree(array[0, mid])

    # right subtree of root has all values > mid
    root.right = build_tree(array[mid+1, array.length])

    root
  end

  def pretty_print(node=@root, prefix='', is_left=true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = [20, 30], [40, 50], [60, 70], [40, 30], [30, 30], [20, 40]

the_tree = Tree.new(array)

p the_tree.root

puts ""
the_tree.pretty_print