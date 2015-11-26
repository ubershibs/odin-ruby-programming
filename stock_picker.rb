def stock_picker(prices)

buy_day = 0
sell_day = 0
max_profit = 0


prices.each_with_index do |buy_price, i|
	prices[i+1..-1].each_with_index do |sell_price, j|
		if (sell_price - buy_price > max_profit)
			max_profit = sell_price - buy_price
			buy_day = i
			sell_day = j+i+1
		end
	end
end

return [buy_day, sell_day]

end

puts stock_picker([17,3,18,6,9,15,8,6,3,18,10,0])