def caesar_cipher(phrase, shift)
	return "Invalid arguments" unless phrase.is_a?(String) && shift.is_a?(Integer)
	return "Shift must be between 1-25" unless shift.between?(-25, 25)

cipher = []	
phrase.each_char do |c|
	n = c.ord
	case n
	#uppercase letters
	when 65..90
		n = n + shift
		if n > 90
			n = n-26
		end
		cipher.push(n.chr)
	#lowercase letters
	when 97..122 
		n = n + shift
		if n > 122
			n = n-26
		end
		cipher.push(n.chr)
	#all other chars
	else  
		cipher.push(c)
	end
end
puts cipher.join
end

caesar_cipher("Hello !@$my name is zzyrx!@$%@", 18)