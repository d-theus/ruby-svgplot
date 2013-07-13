require 'rasem'

module Svgplot
	class Plot < Rasem::SVGImage
		DefaultStyle = { :stroke => "black", :fill => "black" }

		def initialize(param = {},&block)
			@param = Hash.new
			@param.merge param
			@param[:h] ||= 600 
			@param[:w] ||= 800
			@param[:span] ||= 7
			new_block = Proc.new do
				self.frame 
				self.instance_exec(&block)
			end
			super(@param[:w],@param[:h],&new_block)
		end

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
	end
end



