def bubble_sort(v)
	
	n = 1
	while n < v.length
		i = 0
		until i == v.length-n
			if v[i] > v[i+1]
				v[i], v[i+1] = v[i+1], v[i]
			end
			i += 1
		end
		n += 1
	end
	puts v.join(', ')
end

bubble_sort([4,3,78,2,0,2])


def bubble_sort_by(v)
	
	n = 1
	while n < v.length
		i = 0
		until i == v.length-n
			if (yield v[i], v[i+1]) > 0
				v[i], v[i+1] = v[i+1], v[i]
			end
			i += 1
		end
		n += 1
	end
	puts v.join(', ')

end

bubble_sort_by(["hi", "how is it going", "hello", "hey"]) do |left,right|
   left.length - right.length
end
   