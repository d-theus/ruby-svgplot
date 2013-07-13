require 'ruby/svgplot'

p = Svgplot::Plot.new(:w => 800, :h => 500) do
	bar(
		:data => [10,10,15,10,20,98, 50],
		:captions => [ "group_one", "group_two", "group_three", "group_four", "group_five", "group_six", "group"],
		:style => {"fill-opacity" => "0.4","fill" => "green"}
	)
end
File.open("test/bar.svg","w") do |f|
	f.puts p.output
end
