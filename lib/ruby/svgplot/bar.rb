class Svgplot::Plot
	def text(x, y, text, style=DefaultStyles[:text], transform=nil)
		@output << %Q{<text x="#{x}" y="#{y}"}
		style = fix_style(default_style.merge(style))
		@output << %Q{ font-family="#{style.delete "font-family"}"} if style["font-family"]
		@output << %Q{ font-size="#{style.delete "font-size"}"} if style["font-size"]
		write_style style
		@output << %Q{ transform="#{transform}" } unless transform.nil?
		@output << ">"
		dy = 0      # First line should not be shifted
		text.each_line do |line|
			@output << %Q{<tspan x="#{x}" dy="#{dy}em">}
			dy = 1    # Next lines should be shifted
			@output << line.rstrip
			@output << "</tspan>"
		end
		@output << "</text>"
	end

	def bar(data)
		frame :bar
		return if data[:data].nil?
		opts = data[:options] || {:barwidth => 0.9*(@param[:w] - @param[:span]/2)/data[:data].count}
		st = DefaultStyle.merge data[:style]
		values = data[:data]
		captions = data[:captions] || (1..values.length).to_a.map{ |x| x.to_s }
		h = @param[:h]
		pcnt = h.to_f/100
		w = @param[:w]
		barw = opts[:barwidth]
		s = @param[:span]
		values.each_with_index do |v,i|
			rectangle s+i*barw*1.11111, h - v*pcnt, barw, v*pcnt, st

			wlen = captions[i].length*s*1.7 #font-width needed here
			tx = 2*s+(i+0.5)*barw*1.11111 - wlen/2
			ty = w/2
			if wlen < barw
				transform = nil
			else
				a = 90 - Math.asin(barw/wlen)/Math::PI * 180
				transform = "rotate(#{a.to_i} #{tx+wlen/2}, #{ty})"
			end
			text tx,ty,captions[i] , {}, transform
		end
	end
end
