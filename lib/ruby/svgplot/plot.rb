class Svgplot::FPlot < Svgplot::Plot
	def initialize(param = {}, &block)
		@xr = param[:xrange] ||= [-5.0, 5.0]
		@yr = param[:yrange] ||= [-5.0, 5.0]
		@xt = param[:xticks] ||= 1
		@yt = param[:yticks] ||= 1
		@g = param[:grid] ||= false
		super param, &block
	end
	def plot_single_function(f,style, options)
		x = 0.0
		while x < @param[:w]
			y1 = f.call(trix x)
			y2 = f.call(trix x+1)
			if options[:with_lines]
				line(x, try(y1), x+1, try(y2),style) 
			else
				circle x, try(y1), 1,style
			end
			x += 1
		end
	end

	#straight: actual to pixel
	def trx(x)
		(x - @xr[0])*@param[:w]/(@xr[1] - @xr[0])
	end

	def try(y)
		(@yr[1]-y)*@param[:h]/(@xr[1] - @xr[0])
	end

	#inverses: pixel to actual
	def trix(x)
		# 0 -> xrange_0
		# w -> xrange_1
		@xr[0] + (@xr[1] - @xr[0])*(x/@param[:w]) 
	end

	def triy(y)
		# 0 -> yrange_1
		# h -> yrange_0
		@yr[1] - (@yr[1] - @yr[0])*(y/@param[:h]) 
	end

	private :plot_single_function

	def scales
		w = @param[:w]
		h = @param[:h]
		s = @param[:span]

		tx = @xr[0].floor.to_f - 1.0
		ty = @yr[0].floor.to_f - 1.0

		while tx < @xr[1]
			line 	trx(tx),h+s/2,
				trx(tx),h-s/2
			line 	trx(tx),0+s/2,
				trx(tx),0-s/2
			if @g 
				line 	trx(tx),0,
					trx(tx),h,
					"stroke-dasharray" => "3,3",
					"stroke" => "black",
					"stroke-opacity" => "0.3"
			end
			text trx(tx),h-2*s,tx.to_s,{"font-size"=> (1.2*s).to_s}
			text trx(tx),0+2*s,tx.to_s,{"font-size"=> (1.2*s).to_s}
			tx += 1/@xt.to_f
		end

		while ty < @yr[1]
			line 	0-s/2,try(ty),
				0+s/2,try(ty)
			line 	w-s/2,try(ty),
				w+s/2,try(ty)
			if @g 
				line 	0,try(ty),
					w,try(ty),
					"stroke-dasharray" => "3,3",
					"stroke" => "black",
					"stroke-opacity" => "0.3"
			end
			text 0+s, try(ty), ty.to_s,"font-size" => (1.2*s).to_s
			text w - (1.2*s).to_s.length*s, try(ty), ty.to_s,"font-size" => (1.2*s).to_s
			ty += 1/@xt.to_f
		end
	end

	def plot(data)
		unless @scales_shown 
			@scales_shown = true
			scales
		end
		style = data[:style] ||= DefaultStyle
		opts = data[:options] ||= {:with_lines => false}
		if data[:f]
			f = data[:f]
			if f.class == Proc
				plot_single_function f, style, opts
				@legend << {:desc => data[:desc], :style => style, :type => :line} unless data[:desc].nil?
			end
			if f.class == Array
				f.each_with_index do |foo,i|
					plot_single_function foo, style, opts
				end
			end
		end
		if data[:pairs]
			data[:mark] ||= :cros unless opts[:with_lines]
			data[:pairs].each_with_index do |pair, i|
				if opts[:with_lines]
					line(trx(pair[0]), try(pair[1]),
					     trx(data[:pairs][i+1][0]),try(data[:pairs][i+1][1]), style) unless i+1 >= data[:pairs].size
				else
					mark trx(pair[0]), try(pair[1]), 5,data[:mark], style
				end
			end
			unless data[:desc].nil?
				legend_item = {:style => style, :desc => data[:desc], :type => (opts[:with_lines]?:line : data[:mark])}
				@legend << legend_item
			end
		end
	end

end
