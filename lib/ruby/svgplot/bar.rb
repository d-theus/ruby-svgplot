class Svgplot::BarChart < Svgplot::Plot

	def initialize(param = {},&block)
		super param, &block
	end

	def plot(args)
		style = args[:style] ||= DefaultStyle
		palette = style["fill"].is_a?(Array) ? style["fill"].dup : [style["fill"]]
		raise ArgumentError, "inappropriate data type" if args[:data].nil?
		opts = { 
			:barwidth => nil,
			:show_captions => true,
			:box => {:x => 0,:y => 0,:w => @param[:w],:h => @param[:h]}
		}
		opts.merge! args[:options] unless args[:options].nil?
		st = DefaultStyle.merge args[:style]
		chart_data = args[:data]
		@boxx,@boxy,@boxw,@boxh = opts[:box][:x],opts[:box][:y],opts[:box][:w],opts[:box][:h]
		scales
		h = @boxh
		pcnt = h.to_f/100
		w = @boxw
		s = @param[:span]
		barw = opts[:barwidth] ||= (@boxw - 2 * s)/(chart_data.size + 2)
		step = (w-2*s)/(chart_data.count + 1)

		i = 0
		chart_data.each do |caption, val|
			text trx(s+ (i+0.9)*step),
				try(h/2),
				caption.to_s if opts[:show_captions]
			if val.class == Array
				tot = val.reduce :+
				cur = 0
				val.each_with_index do |v,j|
					style["fill"] = pick_color j, palette
					rectangle s+(i+1)*step - barw/2, h - pcnt*(tot - cur), barw, pcnt*v, style
					cur += v
				end
			else
				style["fill"] = pick_color i,palette
				rectangle trx(s+(i+1)*step - barw/2),
					try(h - pcnt*val),
					barw,
					pcnt*val,
					style
			end
			i+=1
		end
		@legend << {:desc => args[:desc], :type => :rect, :style => style} unless args[:desc].nil?
	end

	private
	def trx x
		-100
		@boxx+x unless x > @boxw
	end

	def try y
		-100
		@boxy+y unless y > @boxh
	end

	def grid
	end

	def scales
		st = {
			"stroke" => "#111111"
		}
		line trx(0),try(0),trx(0),try(@boxh), st
		line trx(@boxw),try(@boxh), trx(0),try(@boxh), st
	end

end
