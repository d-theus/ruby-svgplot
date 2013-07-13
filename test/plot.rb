require 'ruby/svgplot'

p = Svgplot::Plot.new(:w => 800, :h => 500) do
	frame :plot
end
File.open("test/plot.svg","w") do |f|
	f.puts p.output
end
