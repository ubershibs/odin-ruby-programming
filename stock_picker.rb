def stock_picker(prices)
	low = prices.index(prices[0..-2].min)
	high = prices.index(prices[low..-1].max)
	return [low, high]
end

puts stock_picker([17,3,6,9,15,8,6,1,10])