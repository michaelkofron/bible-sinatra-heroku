class CreateQuotes

    attr_accessor :link

    def initialize(link)
        @link = link
    end

    def get_page
        link = @link
        page = Nokogiri::HTML(open(link.to_s))
        page
    end

    def scrape_and_create
        use_page = get_page
        quotes = use_page.css("p").collect {|quote| quote.text.strip}
        references = use_page.css("a").css(".bibleref").collect {|ref| ref.text.strip}
        
        quotes.shift(4)
        quotes.pop(2)

        combined_array = references.zip quotes
        counter = 0

        combined_array.each do |ref, quote|
            Quotes.new(ref, quote)
        end
    end

    def many_quotes(number)
        counter = 0

        number.times do
            value = rand(1..8)
            puts ""
            amount = Quotes.all_refs[value].length
            amount.times do
                print "="
            end
            puts ""
            puts Quotes.all_refs[value]
            amount.times do
                print "="
            end
            puts ""
            puts Quotes.all_quotes[value]
            counter +=1
        end
    end

    def clear
        Quotes.all_refs.clear
        Quotes.all_quotes.clear
    end
end