require 'ruby/svgplot'

p = Svgplot::FPlot.new(:w => 800, :h => 500, :grid => true) do
	plot :f => lambda{|x| return Math.cos(x)}
	plot :f => lambda{|x| return Math.atan(x)}, 
		:style => {"stroke" => "blue"},
		:desc => "atan x"
	plot :pairs => [1.1, 2.5, -1.3].zip([1.5,-1,2.3]),
		:desc => "cross"
	plot :pairs => [1.5, 2.5, -2.3].zip([1.5,-1,2.3]),
		:desc => "triangle",:mark => :tria
	plot :pairs => [3.1, 2.5, 1.3].zip([1.5,-1,2.3]),
		:desc => "circle", :mark => :circ
	plot :pairs => [-1.1, -2.5, 1.3].zip([1.5,-1,2.3]),
		:desc => "rectangle", :mark => :rect
end
File.open("test/plot.svg","w") do |f|
	f.puts p.output
end
