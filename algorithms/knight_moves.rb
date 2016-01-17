class Knight
 attr_reader :rows, :cols, :queue, :route

  def initialize(start, finish)
    @start = start
    @finish = finish
    @queue = Array.new
    @route = Array.new
    begin_sim
  end

  def is_valid(location)
    return false unless location.is_a?(Array)
    if location[0].between?(0,7) && location[1].between?(0,7)
      return true
    else
      return false
    end
  end

  def possible_moves(node)
    poss = Array.new
    poss[0] = [(node.location[0]+2), (node.location[1]+1)]
    poss[1] = [(node.location[0]+2), (node.location[1]-1)]
    poss[2] = [(node.location[0]-2), (node.location[1]+1)]
    poss[3] = [(node.location[0]-2), (node.location[1]-1)]
    poss[4] = [(node.location[0]-1), (node.location[1]+2)]
    poss[5] = [(node.location[0]-1), (node.location[1]-2)]
    poss[6] = [(node.location[0]+1), (node.location[1]+2)]
    poss[7] = [(node.location[0]+1), (node.location[1]-2)]
    
    poss.each do |set| 
      if is_valid(set)
        @queue << Node.new(set, node)
      end
    end
  end

   def calculate_route(start, finish)
    while @queue.empty? == false
      current_node = @queue.shift
      if current_node.location == start 
        return current_node
      else
        possible_moves(current_node)
      end
    end
  end

  def map_route(node)
    puts "[#{node.location[0]}, #{node.location[1]}]"
    if node.parent.nil?
      return
    else
      map_route(node.parent)
    end
  end

   def begin_sim
    puts  "Bad start coordinates" if is_valid(@start) == false
    puts "Bad end coordinates" if is_valid(@finish) == false
    if is_valid(@finish) && is_valid(@start)
      @queue << Node.new(@finish, nil)
      routing = calculate_route(@start, @finish)
      puts "Your shortest route:"
      map_route(routing)
    end
  end

end

class Node
  attr_accessor :location, :parent

  def initialize(location, parent=nil)
    @location = location
    @parent = parent
  end

end

knight = Knight.new([0,0], [0,7])

=begin
1. User inputs knight start and end
2. validate that coordinates are valid for both
3. Calculate all possible moves from destination
4. If any of those possibles is the origin, end
5. If not, add all possibles to queue
6. Repeat 3-5 until destination is reached
7. Do a depth-first search back to the destination, adding each node touched to the route 
=end