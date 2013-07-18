# Ruby::Svgplot

Use this library if you need plots in SVG
format.

On the moment it does

* plot one-argument functions
* draw bar chart
* draw pie chart

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-svgplot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-svgplot

## Usage

####Plotting functions
First of all, create an object `FPlot`:

    p = Svgplot::FPlot.new(:w => 800, :h => 500, :grid => true) do
<a id="params"></a>
Parameters are:

* `:w`,`:h` for image width and height
* `:xrange`, `:yrange` for ranges respectively for x and y axis
* `:xtick`, `:ytick` for tick size respectively for x and y axis
* `:grid` to show or hide grid

All interesting part is in the block which is passed to `new`. Here you can plot

* a single function using `plot`,
* multiple functions via multiple calls of `plot`
* array of functions(fixed style for each)
* set of numeric plane points

Here is more on the parameters, more presicely keys of parameter hash of `plot`:

* `:f` for function or function array
* `:pairs` for array of pairs of numeric values
	* `:mark` to choose mark representing current set of points  
Available are `:rect`,`:circ`,`:tria`,`:cros`.
* `:desc` for descriptions for each item.

Example:
    
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

####Drawing bar charts

`Svgplot::BarChart` used for that purpose. It visualises a hash `{:caption => :value}`, where captions is what will be written on x axis. `:value` could be single numeric value or array. Parameters are the [same](#params), besides `:xrange` and `:xtick`, no need in them. `plot` function is still the way to draw it. Parameters in this context are:

* `:data` - a hash
* `:desc` - descriptions  
If value is single number, then :desc is string.  
If array is used as value, then :desc is an array of strings.
* `:style`
* `:options`  
 * `:box` to set box geometry for actual barchart. It is used if you want draw captions below  
chart, or if there is some other reason not to populate all the image. `{:h, :w, :x, :y}`
 * `:captions_pos` to set, where captions will be drawn: `:top`, `:middle`, `:bottom`, `:below`

Example:

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request