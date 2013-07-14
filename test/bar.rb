require 'ruby/svgplot'

p = Svgplot::BarChart.new(:w => 800, :h => 500) do
	plot(
		:desc => "Ohh, some fancy data",
		:data => {
			"group_one" => 10,
			"group_two" => 90,
			"group_three" => 55
		},
		:style => {
			"fill-opacity" => "0.4",
			"fill" => "green",
			"stroke" => "black"
		},
		:options => {
			:show_captions => false,
			:barwidth => 100
		}
	)
end
File.open("test/bar.svg","w") do |f|
	f.puts p.output
end
