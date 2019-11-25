class Quotes

    @@refs = []
    @@quotes = []

    def initialize(ref, quote)
        @ref = ref
        @quote = quote
        @@refs << @ref
        @@quotes << @quote
        
    end

    def self.all_refs
        @@refs
    end

    def self.all_quotes
        @@quotes
    end
end