require './Responder'

class WhatResponder < Responder
	def response(input, parts, mood)
		return"#{input}ってなに？"
	end
end