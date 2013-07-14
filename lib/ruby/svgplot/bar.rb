class Svgplot::BarChart < Svgplot::Plot

	def initialize(param = {},&block)
		super param, &block
	end

	def plot(args)
		style = args[:style] ||= DefaultStyle
		raise ArgumentError, "inappropriate data type" if args[:data].nil?
		opts = { :barwidth => (@param[:w] - 2*@param[:span])/args[:data].count, :show_captions => true }
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
			text (i+0.1) * barw, h/2, caption.to_s if opts[:show_captions]
			if val.class == Array
				#some rocket science
			else
				rectangle s+(i+1)*step - barw/2, h - pcnt*val, barw, pcnt*val, style
			end
			i+=1
		end
		@legend << {:desc => args[:desc], :type => :rect, :style => style} unless args[:desc].nil?
	end

	def scales
	end
end
