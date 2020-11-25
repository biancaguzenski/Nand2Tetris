require_relative 'symboltable'
require_relative 'parser'
class Asembler

    SYMBOLTABLE = {
        'SP'   => 0,
        'LCL'  => 1,
        'ARG'  => 2,
        'THIS' => 3,
        'THAT' => 4,
        'R0' => 0,
        'R1' => 1,
        'R2' => 2,
        'R3' => 3,
        'R4' => 4,
        'R5' => 5,
        'R6' => 6,
        'R7' => 7,
        'R8' => 8,
        'R9' => 9,
        'R10' => 10,
        'R11' => 11,
        'R12' => 12,
        'R13' => 13,
        'R14' => 14,
        'R15' => 15,
        'SCREEN' => 0x4000,
        'KBD'    => 0x6000
    };

    def asembler(file)
        # open file and generate symbol table
        code_lines = open(file)
        symboltable = SymbolTable.new(SYMBOLTABLE)
        parser = Parser.new(code_lines)
        address = 16;
        parser.parser(symboltable, address)
        # generate file .hack
        filename = File.basename(file.split('/').last, '.asm')
	    file =File.open(filename+".hack", 'w')
	    file.puts(parser.code_generator)
    end
end


as = Asembler.new
as.asembler('Rect.asm')