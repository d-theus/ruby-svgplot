require 'rasem'

module Svgplot
	class Plot < Rasem::SVGImage
		DefaultStyle = { "stroke" => "black", "fill" => "black", "font-size" => 14 }
		DefaultPalette = [ "steelblue", "indianred", "seagreen", "thistle", "khaki", "cadetblue", "lightsalmon", "amethyst", "palevioletred" ]

		def initialize(param = {},&block)
			@param = Hash.new
			@param.merge param
			@param[:h] ||= 600 
			@param[:w] ||= 800
			@param[:span] ||= 7
			@legend = Array.new
			new_block = Proc.new do
				self.frame 
				self.instance_exec(&block)
				self.legend @legend
			end
			super(@param[:w],@param[:h],&new_block)
		end
		protected
		def frame
			w = @param[:w]
			h = @param[:h]
			s = @param[:span]
			 
			line 0,0,0,h
			line 0,0,w,0
			line w,0,w,h
			line 0,h,w,h

			#when :bar then
				#ty = 0.0
				#while ty < h
					#line w-s, ty, w, ty
					#line 0, ty, s, ty
					#mark = (1.0-ty/h)
					#text 0+s, ty, mark.round(2).to_s,"font-size" => (1.2*s).to_s
					#text w - 4*s, ty, (1.0-ty/h).round(2).to_s,"font-size" => (1.2*s).to_s
					#ty += h/@param[:yticks]
				#end
			#when :pie then
				#puts "pie"
			#else raise ArgumentError, "Unknown or undefined type: #{type.to_s}"
			#end
		end

		def legend(styles,x = 0.75*@param[:w],y = 0.05*@param[:h])
			return unless styles.any?
			w = @param[:w]
			h = @param[:h]
			s = @param[:span]

			fs = 12
			lh = (1 + styles.count*1.45)*fs
			lw = 0.3*h
			lnh = fs+fs/3

			rectangle x,y, lw, lh, "fill" => "grey", "fill-opacity" => "0.3"
			styles.each_with_index do |st,i|
				ly = 0.7*fs + y + lnh*(i+0.5)
				case st[:type]
				when :line then
					line x+lw/12, ly-fs/3,x+lw/3, ly-fs/3,st[:style]
				when :cros,:rect,:circ,:tria then
					mark x + lw*0.125, ly-fs/3, fs*0.8, st[:type], st[:style]
				else
					text x+lw/12, ly, "unknown type", "fill" => "red"
				end
				text x+lw/2.75,ly, st[:desc], "font-size" => fs.to_s
			end
		end
		def mark(x,y,size=@param[:span],type=:cros, style = DefaultStyle)
			s2 = size/2
			case type
			when :cros then
				line x-s2, y-s2, x+s2, y+s2, style
				line x-s2, y+s2, x+s2, y-s2, style
			when :circ then
				circle x,y,s2,style
			when :rect then
				rectangle x-s2,y-s2,size,size,style
			when :tria then
				polygon x-s2,y+s2,x,y-s2,x+s2,y+s2,style
			else raise ArgumentError, "Unknown marker type"
			end
		end
		def path(path,style = DefaultStyle, transform = nil)
			@output << %Q{<path d="#{path}"}
			write_style style
			@output << %Q{ transform="#{transform}" } unless transform.nil?
			@output << " />"
		end

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

		def pick_color i,user_palette=DefaultPalette
			n = user_palette.size
			user_palette[i % n]
		end
	end
end



