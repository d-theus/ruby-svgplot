class Svgplot::BarChart < Svgplot::Plot

	def initialize(param = {},&block)
		super param, &block
	end

	def plot(args)
		style = args[:style] ||= DefaultStyle
		palette = style["fill"].is_a?(Array) ? style["fill"].dup : [style["fill"]]
		raise ArgumentError, "inappropriate data type" if args[:data].nil?
		opts = { :barwidth => (@param[:w] - 2*@param[:span])/(args[:data].count+2), :show_captions => true }
		opts.merge! args[:options] unless args[:options].nil?
		st = DefaultStyle.merge args[:style]
		chart_data = args[:data]
		h = @param[:h]
		pcnt = h.to_f/100
		w = @param[:w]
		barw = opts[:barwidth]
		s = @param[:span]
		step = (w-2*s)/(chart_data.count + 1)

		i = 0
		chart_data.each do |caption, val|
			text s+ (i+0.9)*step , h/2, caption.to_s if opts[:show_captions]
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
				rectangle s+(i+1)*step - barw/2, h - pcnt*val, barw, pcnt*val, style
			end
			i+=1
		end
		@legend << {:desc => args[:desc], :type => :rect, :style => style} unless args[:desc].nil?
	end

	def scales
	end
end
