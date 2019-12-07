class ProfileController < ApplicationController

    get '/profile' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            @favorites = Favorite.where(:user_id => session[:user_id])
            erb :profile
        else
            redirect '/'
        end
    end

    post '/profile' do
        @favorite = Favorite.create(topic: params[:search], verse: params[:ref], body: params[:quote], user_id: session[:user_id])
        Quotes.clear_all
        redirect "search/#{params[:search]}"
    end

    delete '/delete/:id' do
        favorite = Favorite.find_by id: params[:id]
        favorite.destroy
        redirect '/profile'
    end

end