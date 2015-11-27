def substrings(input, dict)
	count = Hash.new(0)
	word_array = input.split(' ')

	word_array.each do |word|
		dict.each { |s| count[s] += 1 if (word.downcase.include?(s.downcase)) }
	end

	count = count.sort_by {|key, value| key}
	count.each { |key, value| puts "#{key}:#{value}" }
	
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
   
substrings("Howdy partner, sit down! How's it going?", dictionary)