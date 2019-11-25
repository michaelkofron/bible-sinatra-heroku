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
            create_quotes = CreateQuotes.new(link)
            create_quotes.scrape_and_create
            @quotes_references = Quotes.all_refs
            @quotes_texts = Quotes.all_quotes
            if @quotes_references.length == 0
                @quotes_references << "No Results"
                @quotes_texts << "No Results"
            end
            erb :searchresult
        else
            redirect '/'
        end
    end

    post '/profile' do
        ref = params[:ref]
        text = params[:quote]
        search = params[:search]

        @favorite = Favorite.create(topic: params[:search], verse: params[:ref], body: params[:quote], user_id: session[:user_id])

        redirect "search/#{params[:search]}"
    end

    get '/profile' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            @favorites = Favorite.where(:user_id => session[:user_id])
            erb :profile
        else
            redirect '/'
        end
    end

    post '/delete' do
        Favorite.where(verse: params[:ref]).destroy_all
        redirect '/profile'
    end

    post '/deletefromsearch' do
        Favorite.where(verse: params[:ref]).destroy_all
        redirect "search/#{params[:search]}"
    end
end