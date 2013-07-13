require 'ruby/svgplot'

p = Svgplot::FPlot.new(:w => 800, :h => 500, :grid => true) do
	plot :f => lambda{|x| return Math.cos(x)}
	plot :f => lambda{|x| return Math.atan(x)}, 
		:style => {"stroke" => "blue"}
end
File.open("test/plot.svg","w") do |f|
	f.puts p.output
end
