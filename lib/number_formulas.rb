module NumberFormulas

  def format_num(number, places)
    number = 0.00 unless number
    format("%.#{places}f", number).to_f
	end
end