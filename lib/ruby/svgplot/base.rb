require 'rasem'

module Svgplot
	class Plot < Rasem::SVGImage
		DefaultStyle = {
			:stroke => "black",
			:fill => "black"
		}
		def initialize(param = {},&block)
			@param = Hash.new
			@param.merge param
			@param[:h] ||= 600 
			@param[:w] ||= 800
			@param[:xrange] ||= [-5.0,5.0]
			@param[:yrange] ||= [-5.0,5.0]
			@param[:xticks] ||= 100
			@param[:yticks] ||= 20
			@param[:xp] ||= 2
			@param[:yp] ||= 1
			@param[:span] ||= 7
			super(@param[:w],@param[:h],&block)
		end
		#straight: actual to pixel
		def trx(x)
			(x - @param[:xrange][0])*@param[:w]/(@param[:xrange][1] - @param[:xrange][0])
		end

		def try(y)
			2*(@param[:yrange][1]-y)*@param[:h]/(@param[:xrange][1] - @param[:xrange][0])
		end

		#inverses: pixel to actual
		def trix(x)
			# 0 -> xrange_0
			# w -> xrange_1
			@param[:xrange][0] + (@param[:xrange][1] - @param[:xrange][0])*(x/@param[:w]) 
		end

		def triy(y)
			# 0 -> yrange_1
			# h -> yrange_0
			@param[:yrange][1] - (@param[:yrange][1] - @param[:yrange][0])*(y/@param[:h]) 
		end

		def frame(type, settings = {})
			w = @param[:w]
			h = @param[:h]
			s = @param[:span]
			 
			line 0,0,0,h
			line 0,0,w,0
			line w,0,w,h
			line 0,h,w,h

			case type
			when :plot then
				xlabel = settings[:xlabel] || ""
				ylabel = settings[:ylabel] || ""

				tx = @param[:xrange][0].floor.to_f - 1.0
				ty = @param[:yrange][0].floor.to_f - 1.0

				while tx < @param[:xrange][1]
					line 	trx(tx),h+s/2,
						trx(tx),h-s/2
					line 	trx(tx),0+s/2,
						trx(tx),0-s/2
					text trx(tx),h-2*s,tx.to_s,{"font-size"=> (1.2*s).to_s}
					text trx(tx),0+2*s,tx.to_s,{"font-size"=> (1.2*s).to_s}
					tx += 1/@param[:xp].to_f
				end

				while ty < @param[:yrange][1]
					line 	0-s/2,try(ty),
						0+s/2,try(ty)
					line 	w-s/2,try(ty),
						w+s/2,try(ty)
					text 0+s, try(ty), ty.to_s,"font-size" => (1.2*s).to_s
					text w - (1.2*s).to_s.length*s, try(ty), ty.to_s,"font-size" => (1.2*s).to_s
					ty += 1/@param[:yp].to_f
				end
			when :bar then
				ty = 0.0
				while ty < h
					line w-s, ty, w, ty
					line 0, ty, s, ty
					mark = (1.0-ty/h)
					text 0+s, ty, mark.round(2).to_s,"font-size" => (1.2*s).to_s
					text w - 4*s, ty, (1.0-ty/h).round(2).to_s,"font-size" => (1.2*s).to_s
					ty += h/@param[:yticks]
				end
			when :pie then
				puts "pie"
			else raise ArgumentError, "Unknown or undefined type: #{type.to_s}"
			end
		end
	end
end



