# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP                           
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID   
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner 
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		if File.exist?(filename)
			@f = File.open(filename,'r:utf-8')
		else
			put "File does not exist"
		end 
		
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "!eof!"
		end
		
		return @c
	end

	def nextToken() 
		if @c == "!eof!"
			return token = Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str =""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
			token = Token.new(Token::WS, str)

		elsif letter?(@c)
			str = ''
			while letter?(@c)
			  str += @c
			  nextCh()
			end
			
			if (str == "print")
                token = Token.new(Token::PRINT, str)
            else
                token = Token.new(Token::ID, str)
            end
		elsif @c == '='
			nextCh()
			token = Token.new(Token::EQUAL, '=')
	  
		elsif @c == '('
			nextCh()
			token = Token.new(Token::LPAREN, '(')
	  
		elsif @c == ')'
			nextCh()
			token = Token.new(Token::RPAREN, ')')
	  
		elsif @c == '+'
			nextCh()
			token = Token.new(Token::ADDOP, '+')
	  
		elsif @c == '-'
			nextCh()
			token = Token.new(Token::SUBOP, '-')
	  
		elsif @c == '*'
			nextCh()
			token = Token.new(Token::MULTOP, '*')
	  
		elsif @c == '/'
			nextCh()
			token = Token.new(Token::DIVOP, '/')

		elsif numeric?(@c)
			str = ''
			while numeric?(@c)
			  str += @c
			  nextCh()
			end
	  
			token = Token.new(Token::INT, str)

	  
		else
			nextCh()
			token = Token.new("unknown","unknown")
		end
		puts "Next token is: #{token.type} Next lexeme is: #{token.text}"
		return token
	end
end

#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end

