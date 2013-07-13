module Svgplot
	class Plot
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

		def plot(data)
			frame :plot
			style = data[:style] ||= DefaultStyle
			opts = data[:options] ||= {}
			if data[:f]
				f = data[:f]
				if f.class == Proc
					plot_single_function f, style, opts
				end
				if f.class == Array
					f.each do |foo|
						plot_single_function foo, style, opts
					end
				end
			end
			if data[:pairs]
				data[:pairs].each_with_index do |pair, i|
					if opts[:with_lines]
						line(trx(pair[0]), try(pair[1]),
						     trx(data[:pairs][i+1][0]),try(data[:pairs][i+1][1]), style) unless i+1 >= data[:pairs].size
					else
						circle trx(pair[0]), try(pair[1]), 2, style
					end
				end
			end
		end
		private :plot_single_function
	end
end
