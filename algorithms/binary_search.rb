class Node
  attr_accessor :value, :left, :right, :parent, :to_s

  def initialize(value, left = nil, right= nil, parent=nil)
    @value = value
    @left = left
    @right = right
    @parent = parent
  end

  def to_s
    s = "v: #{@value} "
    s += "l: #{@left.is_a?(Integer) ? @left : @left.value} " unless @left.nil?
    s += "r: #{@right.is_a?(Integer) ? @right : @right.value} " unless @right.nil?
    s += "p: #{@parent.is_a?(Integer) ? @parent : @parent.value}" unless @parent.nil?
    return s
  end
end

#Method to build tree from a sorted array
def build_tree_sorted(array, left=0, right=array.length-1, parent=nil)
  return if left > right
  mid = (left + right)/ 2 
  node = Node.new(array[mid], nil, nil, nil)

  node.left = build_tree_sorted(array, left, mid-1, array[mid])
  node.right = build_tree_sorted(array, mid+1, right, array[mid])
  node.parent = parent unless parent.nil?

  node
end


# tree = build_tree_sorted([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

#To build from an unsorted array (not balanced)
class BinarySearchTree
  attr_accessor :array, :root
 
  def initialize(array)
    @array = array
    @root = Node.new(array[0], nil, nil, nil)
  end

  def build_tree
    @array.each do |x|
      add_to_tree(x)
    end
  end

  def add_to_tree(value, current_node = @root)
    unless value == current_node.value
      if value < current_node.value
        current_node.left.nil? ? current_node.left = Node.new(value, nil, nil, current_node.value) : add_to_tree(value, current_node.left)
      else
        current_node.right.nil? ? current_node.right = Node.new(value, nil, nil, current_node.value) : add_to_tree(value, current_node.right)
      end
    end 
  end

  def print_tree(tree)
    puts "Root node : " + tree.root.to_s
    puts "L child:  : "+ tree.root.left.to_s
    puts "R child   : "+ tree.root.right.to_s 
  end

  def bfs(target)
    queue = [@root]

    while queue.empty? == false
      current_node = queue.shift
      if current_node.value == target 
        return "#{target} found in #{current_node.to_s}"
      else
        queue << current_node.left unless current_node.left.nil?
        queue << current_node.right unless current_node.right.nil?
      end
    end
    return "#{target} not found"
  end

  def dfs(target)
    result = dfs_rec(target, @root)
    puts result.nil? ? "Not found" : result 
  end

  def dfs_rec(target, node) 
    return nil if node.nil?
    return node if node.value == target
    
    l = dfs_rec(target, node.left) 
    return l if l && l.value == target 
    r = dfs_rec(target, node.right) 
    return r if r && r.value == target
  end

end

array = [2, 5, 8, 10, 14, 22, 23, 39, 46, 95]
array.shuffle!

new_tree = BinarySearchTree.new(array)
new_tree.build_tree

#cursory check of results
puts "Starting array: " + new_tree.array.join(", ")
new_tree.print_tree(new_tree)
puts "* * * * * * * * * *"
puts "Breadth First Search results"
puts new_tree.bfs(2) 
puts new_tree.bfs(10)
puts new_tree.bfs(22)
puts new_tree.bfs(23)
puts new_tree.bfs(24)
puts "* * * * * * * * * *"
puts "Depth First Search results"
new_tree.dfs(2)
"Not found" if new_tree.dfs(10).nil?
"Not found" if new_tree.dfs(22).nil?
"Not found" if new_tree.dfs(23).nil?
"Not found" if new_tree.dfs(24).nil?