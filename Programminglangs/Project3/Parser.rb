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
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner
	@@errorCount = 0
	def initialize(filename)
    	super(filename)
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
			@@errorCount = @@errorCount + 1
      	end
      	consume()
   	end
   	
	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()  
      	end
		puts "There were " + @@errorCount.to_s + " parse errors found."
   	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
			puts "Exiting ASSGN Rule"
		end
		
		puts "Exiting STMT Rule"
	end


	def assign()
		id_rule()
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		exp()
	end

	def exp()
		puts "Entering EXP Rule"
		term()
		puts "Exiting EXP Rule"
		if (@lookahead.type == Token::RPAREN)
			puts "Found RPAREN Token: #{@lookahead.text}"
			consume()
		end 
	end

	def id_rule()
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
		end
		match(Token::ID)
	end
	
	def term() 
		puts "Entering TERM Rule"
		factor()
		puts "Exiting TERM Rule"
		puts "Entering ETAIL Rule"
		etail()
		puts "Exiting ETAIL Rule"
	end 

	def factor()
		puts "Entering FACTOR Rule"
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN Token: #{@lookahead.text}"
			consume()
			exp()
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@@errorCount = @@errorCount + 1
			consume()
		end
		puts "Exiting FACTOR Rule"
		puts "Entering TTAIL Rule"
		ttail()
		puts "Exiting TTAIL Rule"
	end
		
	def ttail()
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP Token: #{@lookahead.text}"
			consume()
			factor()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP Token: #{@lookahead.text}"
			consume()
			factor()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
	end
	
	def etail()
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP Token: #{@lookahead.text}"
			consume()
			term()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP Token: #{@lookahead.text}"
			consume()
			term()
		else
			puts"Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end
	end
end 
