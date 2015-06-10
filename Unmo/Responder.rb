class Responder
	def initialize(name, dictionary) #dicitonary = Dictionary Object
		@name = name
		@dictionary = dictionary
	end

	def response(input, parts,mood)
		return ""
	end

	attr_reader :name
#	def name
#		return @name
#	end
end