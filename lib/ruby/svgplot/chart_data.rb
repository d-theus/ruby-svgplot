class Svgplot::ChartData < Hash
	#key --- caption
	#value --- values array
	def initialize(args)
		super args
	end

	def captions
		return self.keys
	end

	def valid?
		self.values.any?(:nil?)
	end
end
