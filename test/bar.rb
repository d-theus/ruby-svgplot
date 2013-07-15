require 'ruby/svgplot'

p = Svgplot::BarChart.new(:w => 800, :h => 500) do
	plot(
		:desc => "Ohh, some fancy data",
		:data => { 
			"1" => 6, "4" => 6, "2" => 7, "4" => 9, "5" => 11,
			"3" => 6, "x" => 6, "g2" => 7, "a4" => 9, "q5" => 11
		},
		:style => {
			"fill-opacity" => "0.4",
			"fill" => ["green"],
			"stroke" => "black"
		}
	)
end
p2 = Svgplot::BarChart.new(:w => 800, :h => 500) do
	plot(
		:data => {
			"cap1" => [40,5,6],
			"cap2" => [6,7,8],
			"cap3" => [1,2]
		},
		:style => {
			"fill" => ["green", "black"]
		}
	)
end
File.open("test/bar.svg","w") do |f|
	f.puts p.output
end
File.open("test/bar2.svg","w") do |f|
	f.puts p2.output
end
