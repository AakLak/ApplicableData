def blah
	return 'blahhh'
end

def score(percent)
	case percent
	when 0.0..0.2
		1
	when 0.21..0.4
		2
	when 0.41..0.6
		3
	when 0.61..0.8
		4
	when 0.81..1.0
		5
	else
		"Error"
	end
end