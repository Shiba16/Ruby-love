require './Unmo'


puts ("Unmo System prototype : proto")
proto = Unmo.new("proto")
while true
	print("> ")
	input = gets
	input.chomp!
	break if input == ""

	response = proto.dialogue(input)
#	puts(prompt(proto) + response)
	puts(proto.prompt + response)
end