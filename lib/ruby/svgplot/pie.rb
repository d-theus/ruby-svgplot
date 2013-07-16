class Svgplot::PieChart < Svgplot::Plot
	def initialize(param = {}, &block)
		super param, &block
	end

	def plot(data)
		raise ArgumentError, "  :data type is unknown or nil, expecting hash" if data[:data].nil? or not data[:data].is_a?(Hash)
		style =  DefaultStyle
		opts = {:one_piece => true, :show_captions => true} 
		opts.merge!(data[:options]) unless data[:options].nil?
		style.merge!(data[:style]) unless data[:style].nil?
		palette = style[:fill].is_a?(Array) ? style[:fill].dup : DefaultPalette

		d = data[:data]

		h = @param[:h]
		w = @param[:w]
		r = [h,w].min/2.6

		fs = style["fontsize"]
		style[:fill] = pick_color(d.size, palette)
		circle(w/2,h/2,r) if opts[:one_piece]
		sum = 0
		i = 0
		d.each_pair do |k,v|
			txt = "#{k+" " if opts[:show_captions]}#{v*100}%"
			a = 2*Math::PI*(sum)
			anew = 2*Math::PI*(v+sum)
			ahalf = 0.5*(anew + a)
			x,y = translate a,r
			xn,yn = translate anew,r
			tx,ty = translate ahalf, opts[:show_captions] ? r : 1.05 * r
			if ahalf >= Math::PI/2 and ahalf < Math::PI
				tx -= txt.to_s.length * fs/1.5
			end
			if ahalf >= Math::PI and ahalf < 1.5*Math::PI
				tx -= txt.to_s.length * fs/1.5
				ty += fs
			end
			if ahalf >= 1.5*Math::PI and ahalf < 2*Math::PI
				ty += fs
			end
			style[:fill] = pick_color i, palette
			path %Q{M #{w/2},#{h/2} L #{x},#{y}, A#{r},#{r} 0 0 0 #{xn},#{yn} z},
			style,
				"translate(#{0.05*r*Math::cos(ahalf)},#{-0.05*r*Math::sin(ahalf)})"
			text tx,ty,txt.to_s
			@legend << {:desc => k, :type => :rect, :style => style.dup}
			sum += v
			i+=1
		end
	end

	private 
	def translate a,r
		w,h = @param[:w],@param[:h]
		x,y = w/2 + r*Math::cos(a), h/2 - r*Math::sin(a)
	end

end
