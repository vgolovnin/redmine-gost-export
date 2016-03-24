
class Lexem

attr_accessor :type, :content



end



class LexicalParser

def initialize
	@wiki = File.open("a.wiki", 'r')
end

def getc
	@wiki.getc
end

end


parser = LexicalParser.new

# INIT

state = :initial
lexems = []
buf = ''

while true
c = parser.getc

case c
when nil
	lexems << buf
	break

when "\n"
lexems << buf if buf
lexems << c

when '['
	if buf == '[' then 
		lexems << '[['
		buf = ''
	else
		p buf
		buf = c
	end

when ']'
	if buf == ']' then
		lexems << ']]'
		buf = ''
	else
		lexems << buf
		buf = c
	end

else # common symbol
	buf += c
end	


end


lexems.each do |lex|

p lex
end