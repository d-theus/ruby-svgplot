require 'ruby/svgplot'
p = Svgplot::PieChart.new(
:w => 600, :h => 400) do
	plot(
		:data => {
			"one" => 0.3,
			"two" => 0.2,
			"3" =>  0.1,
			"4" =>  0.1,
			"5" =>  0.1,
			"6" =>  0.1,
			"7" =>  0.1
		},
		:options => {
			:show_captions => false,
			:one_piece => false
		}
	)
end

File.open "test/pie.svg","w" do |f|
	f.puts p.output
	f.close
end
	
