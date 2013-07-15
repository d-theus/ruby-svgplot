class Svgplot::PieChart < Svgplot::Plot
	def initialize(param = {}, &block)
		super param, &block
	end

	def plot(data)
		raise ArgumentError, "  :data type is unknown or nil, expecting hash" if data[:data].nil? or not data[:data].is_a?(Hash)
		style =  DefaultStyle
		style.merge!(data[:style]) unless data[:style].nil?

		d = data[:data]

		h = @param[:h]
		w = @param[:w]
		r = [h,w].min/2.6

		circle(w/2,h/2,r)
		sum = 0
		i = 0
		d.each_pair do |k,v|
			a = 2*Math::PI*(sum)
			anew = 2*Math::PI*(v+sum)
			x,y = translate a,r
			xn,yn = translate anew,r
			style[:fill] = pick_color(i)
			path %Q{M #{w/2},#{h/2} L #{x},#{y}, A#{r},#{r} 0 0 0 #{xn},#{yn} z},style
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
