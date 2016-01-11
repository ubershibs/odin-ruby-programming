def mergesort(array)
  return array if array.length == 1
  a = mergesort(array.slice!(0,array.length/2))
  b = mergesort(array)
  merge(a,b)
end
    
def merge(a,b)
  sorted_arr = []
  until a.empty? || b.empty?
    a[0] < b[0] ? sorted_arr << a.shift : sorted_arr << b.shift
  end
  result = sorted_arr + a + b

  return result
end 

list = 7.times.map{rand(200) + 1}
puts list.join(", ")
puts "sorting..."
puts mergesort(list).join(", ")
