class Svgplot::BarChart < Svgplot::Plot

	def initialize(param = {},&block)
		@yr = param[:yrange]
		@yt = param[:yticks]
		@g = param[:grid]
		super param, &block
	end

	def plot(args)
		raise ArgumentError, "inappropriate data type" if args[:data].nil?
		opts = { 
			:barwidth => nil,
			:captions_show => true,
			:captions_pos => :middle,
			:box => {:x => 0.05*@param[:w],:y => 0.05*@param[:h],:w => 0.8*@param[:w],:h => 0.6*@param[:h]}
		}
		opts.merge! args[:options] unless args[:options].nil?
		style = DefaultStyle.merge args[:style]
		palette = style["fill"].is_a?(Array) ? style["fill"].dup : [style["fill"]]
		chart_data = args[:data]

		@boxx,@boxy,@boxw,@boxh = opts[:box][:x],opts[:box][:y],opts[:box][:w],opts[:box][:h]
		@fs = style["font-size"]
		h = @boxh
		w = @boxw
		s = @param[:span]
		barw = opts[:barwidth] ||= (@boxw - 2 * s)/(chart_data.size + 2)
		@step = (w-2*s)/(chart_data.count + 1)


		if @yr.nil?
			if chart_data.values[0].is_a?(Array)
				vals = chart_data.values.map {|v| v.reduce :+}
			else
				vals = chart_data.values
			end
			offset = (vals.max - vals.min)/20.0
			@yr = [0.0, vals.max + offset].map(&:to_f)
			@yt ||= vals.max/20.0
		end
		if @yt.nil?
			@yt = (@yr[1] - @yr[0])/20.0
		end

		caption_max_length = chart_data.keys.map{|k| k.to_s.length}.max
		if barw < 0.65*@fs*caption_max_length
			@angle = 180 / Math::PI *
				Math::acos(barw/(0.65*@fs*caption_max_length))
		else @angle = 0.0
		end

		scales 

		i = 0
		chart_data.each do |caption, val|
			if val.class == Array
				tot = val.reduce :+
				cur = 0.0
				val.each_with_index do |v,j|
					style["fill"] = pick_color j, palette
					rectangle trx(s+(i+1)*@step - barw/2),
						try(@boxh - convert_val(tot - cur)),
						barw,
						convert_val(v),
						style
					cur += v.to_f
				end
			else
				style["fill"] = pick_color i,palette
				rectangle trx(s+(i+1)*@step - barw/2),
					try(@boxh - convert_val(val)),
					barw,
					convert_val(val),
					style
			end
			print_caption i, caption, opts[:captions_pos],style
			i+=1
		end
		 
		unless args[:desc].nil?
			args[:desc] = [args[:desc]] unless args[:desc].is_a?(Array)
			args[:desc].each_with_index do |d,i|
				style["fill"] = pick_color i,palette
				@legend << {:desc => d, :type => :rect, :style => style}
			end
		end
	end

	private
	def print_caption(i, caption, pos, style = DefaultStyle)
			caplen = caption.to_s.length * @fs*0.65
			tx = trx((i+0.65)*@step)
			ty = case pos
			     when :top then
				     try @fs
			     when :middle then
				     try(@boxh/2)
			     when :bottom then
				     @angle = -@angle.abs
				     try(@boxh)
			     when :below then
				     @boxy + @boxh + @fs
			     else 
				     try(@boxh/2)
			     end
			text tx,ty,
				caption.to_s ,
				style,
				"rotate(#{@angle},#{tx},#{ty})"
	end

	def trx x
		-100
		@boxx+x unless x > @boxw
	end

	def try y
		-100
		@boxy+y unless y > @boxh
	end

	def convert_val val
		res = (val.to_f - @yr[0]) / (@yr[1] - @yr[0]) * @boxh.to_f
		res >= 0 ? res : @boxh
	end

	def scales(logscale = false)
		st = {
			"stroke" => "#111111"
		}
		line trx(0),try(0),trx(0),try(@boxh), st
		line trx(@boxw),try(@boxh), trx(0),try(@boxh), st
		scalefactor = 1/(@yr[1] - @yr[0])
		len = @yr[1] - @yr[0]

		if len < 10e-4
			digits = 6
		elsif len < 10e-2
			digits = 3
		elsif len < 1
			digits = 2
		elsif len < 100
			digits = 1
		else 
			digits = 0
		end

		fontsize = @boxh * 0.03

		y=@yr[0]
		while y <= @yr[1]
			if @g
				line trx(0),
					try(@boxh - convert_val(y)),
					trx(@boxw-1),
					try(@boxh - convert_val(y)),
					{"stroke" => "gray", "stroke-opacity" => "0.5" }
			else
				line trx(0),
					try(@boxh - convert_val(y)),
					trx(@param[:span]),
					try(@boxh - convert_val(y))
			end
			text trx(@param[:span]+2),
				try(@boxh - convert_val(y)) - fontsize*0.3,
				y.round(digits).to_s,
				{
					"font-size" => fontsize
				}
			y+=@yt
		end

	end

end
