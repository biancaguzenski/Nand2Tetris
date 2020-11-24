class Parser
	# C instruction

    DEST = {
	''  => '000',
	'M'   => '001',
	'D'   => '010',
	'MD'  => '011',
	'A'   => '100',
	'AM'  => '101',
	'AD'  => '110',
    'AMD' => '111'
    }

    COMP = {
	'0'   => '0101010',
	'1'   => '0111111',
	'-1'  => '0111010',
	'D'   => '0001100',
	'A'   => '0110000',
	'!D'  => '0001101',
	'!A'  => '0110001',
	'-D'  => '0001111',
	'-A'  => '0110011',
	'D+1' => '0011111',
	'A+1' => '0110111',
	'D-1' => '0001110',
	'A-1' => '0110010',
	'A+D' => '0000010',
	'D+A' => '0000010',
	'D-A' => '0010011',
	'A-D' => '0000111',
	'D&A' => '0000000',
	'A&D' => '0000000',
	'D|A' => '0010101',
	'A|D' => '0010101',
	'M'   => '1110000',
	'!M'  => '1110001',
	'-M'  => '1110011',
	'M+1' => '1110111',
	'M-1' => '1110010',
	'D+M' => '1000010',
	'M+D' => '1000010',
	'D-M' => '1010011',
	'M-D' => '1000111',
	'D&M' => '1000000',
	'D|M' => '1010101',
	'M&D' => '1000000',
	'M|D' => '1010101',
    }

    JUMP = {
	''    => '000',
	'JGT' => '001',
	'JEQ' => '010',
	'JGE' => '011',
	'JLT' => '100',
	'JNE' => '101',
	'JLE' => '110',
	'JMP' => '111'
    }

    def initialize(code_lines)
        @lines = reject_comments_whitespaces(code_lines)
    end
    
	def reject_comments_whitespaces(code_lines)
		code_lines.map { |line| line.gsub(%r{//.*$}, '').strip }.reject(&:empty?)
	end

	def parser(symboltable, address)
		@code_generator = []
		check_label(symboltable)
		@lines.each do |line|
			@current = line
			if current.start_with?("@")
				current.delete_prefix! "@"
				if current.match?(/\D/)
					if symboltable.!contain?(@current)
						symboltable.add_new(line, address)
						address+=1
						@code_generator.push('0%015b' % current)
					end
				else
					@code_generator.push('0%015b' % current)
				end
			elsif current.start_with?("(")
				next
			else
				# C-INSTRUCTION
				@code_generator.push('111'+COMP[comp]+DEST[dest]+JUMP[jump])
			end
		end 
		@code_generator    
	end
	
	def check_label(symboltable)
		address = 0
		@lines.each do |line|
			if line.start_with?("(")
				symboltable.add_new(current.slice(1...-1), address)
			else
				address+=1
			end
		end
	end

	def dest
		if current.include?('=')
		  current.split('=').first
		else
		  ''
		end
	end
	
	def comp

		current
		  .split('=').last
		  .split(';').first
	end

	def jump
		if current.include?(';')
		  current.split(';').last
		else
		  ''
		end
	end

	attr_reader :code_generator, :current
end