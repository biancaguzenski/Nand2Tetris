class SymbolTable
    attr_reader :symboltable
    
    def initialize(symboltable)
        @symboltable = symboltable
    end

    def contain?(symbol)
    end

    def add_new(line, address)
        symboltable[line] = address
    end
end