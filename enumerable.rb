module Enumerable

  def my_each
  	return self unless block_given?
  	for i in self
  		yield(i)
  	end
  end

  def my_each_with_index
  	return self unless block_given?
  	for i in 0..length
  		yield(self[i], i)
  	end
  end

  def my_select
  	return self unless block_given?
  	my_results = []
  	my_each {|i| my_results << i if yield(i)}
  	my_results
  end

  def my_all?
  	if block_given?
  		my_each {|i| return false unless yield(i)}
  	else
  		my_each {|i| return false unless i}
  	end
  	true
  end

  def my_any?
	if block_given?
  		my_each {|i| return true if yield(i)}
  	else
  		my_each {|i| return true if i}
  	end
  	false
  end

 def my_none?
	if block_given?
  		my_each {|i| return false if yield(i)}
  	else
  		my_each {|i| return false if i}
  	end
  	true
  end

  def my_count(arg=nil)
  	counter = 0
  	my_each do |i|
  		if block_given?
	    	counter += 1 if yield(i)
	 		elsif arg != nil
				counter += 1 if i == arg 
	  	else
	  		counter += 1
	  	end
	  end
		counter
  end

=begin Original my_map method
  def my_map
  	my_results = []
		if block_given?
			self.my_each { |i| my_results << yield(i) }
			return my_results
  	else
  		return self
  	end
  end
=end 

=begin Runs a proc
  def my_map(&my_proc)
  	my_results = []
		self.my_each { |i| my_results << my_proc.call(i) }
		return my_results
  end
=end

  def my_map(proc=nil)
    my_results = []
    if proc && block_given?
      self.my_each {|i| my_results << proc.call(yield(i))}
      return my_results
    else
      return self
    end
  end

  def my_inject(n = nil)
  	memo = n.nil? ? first : n
		my_each { |i| memo = yield(memo, i) }
		memo
  end

end

def multiply_els(my_array)
	my_array.my_inject(1) { |product, i| product * i }
end