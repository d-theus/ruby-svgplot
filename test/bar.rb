require 'ruby/svgplot'

p = Svgplot::BarChart.new(:w => 800, :h => 500, :grid => true, :yrange => [6,12]) do
	plot(
		:desc => "Ohh, some fancy data",
		:data => { 
			"1" => 6, "4" => 6, "2" => 7, "4" => 9, "5" => 11,
			"3" => 6, "x" => 6, "g2" => 7, "a4" => 9, "q5" => 11
		},
		:style => {
			"fill-opacity" => 0.5,
			"fill" => ["green"],
			"stroke" => "black"
		},
		:options => {
			:box => {
				:x => 15,
				:y => 35,
				:h => 450,
				:w => 700
			},
			:captions_pos => :below
		}
	)
end
p2 = Svgplot::BarChart.new(:w => 800, :h => 500, :grid => true) do
	plot(
		:data => {
			"cap1" => [40,5,6],
			"longcap" => [6,7,8],
			"sooooo long cap" => [1,2]
		},
		:style => {
			"fill" => ["green", "black"],
			"stroke" => "magenta"
		},
		:options => {
			:captions_pos => :below
		},
		:desc => [ "source1", "source2", "source3" ]
	)
end
File.open("test/bar.svg","w") do |f|
	f.puts p.output
end
File.open("test/bar2.svg","w") do |f|
	f.puts p2.output
end
