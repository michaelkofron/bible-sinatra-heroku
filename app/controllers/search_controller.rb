class SearchController < ApplicationController

    get '/search' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            erb :searchpage
        else
            redirect '/'
        end
    end

    post '/search' do
        search = params[:search]
        Quotes.clear_all
        if search.length == 0
            redirect '/search'
        end
        if search.include? " "
            search.gsub!(" ", "_")
        end
        redirect "/search/#{search}"
    end

    get '/search/:search' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            @search = params[:search]
            link = "https://www.openbible.info/topics/#{@search}"
            @search_display = @search.gsub("_", " ")
            create_quotes = CreateQuotes.new(link)
            create_quotes.scrape_and_create
            @quotes_references = Quotes.all_refs
            @quotes_texts = Quotes.all_quotes
            if @quotes_references.length == 0
                @error = "No results match your search"
            end
            erb :searchresult
        else
            redirect '/'
        end
    end

    delete '/deletefromsearch/:id' do
        favorite = Favorite.find_by id: params[:id]
        favorite.destroy
        Quotes.clear_all
        redirect "search/#{params[:search]}"
    end
end