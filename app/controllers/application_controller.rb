require './config/environment'

class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'

        use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => 'foo.com',  
                           :path => '/',
                           :expire_after => 18000, # In seconds
                           :secret => 'some_secret'
    end

    get '/' do
        if logged_in?
            redirect '/search'
        else
            erb :home
        end
    end

    get '/signup' do
        session.clear
        if !logged_in?
            erb :'users/new'
        else
            redirect '/search'
        end
    end

    post '/signup' do
        @user = User.new(username: params[:username], password: params[:password])

        if @user.valid?
            @user.save
            session[:user_id] = @user.id
            redirect '/search'
        else
            @errors = @user.errors.full_messages
            erb :'users/new'
        end
    end


    get '/login' do
        if !logged_in?
            erb :home
        else
            redirect '/search'
        end
    end

    post '/login' do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect '/search'
        else
            if user == nil
                @error = "That username does not exist"
            elsif user && !user.authenticate(params[:password])
                @error = "Incorrect password"
            end
            erb :home
        end
    end

    get '/logout' do
        if logged_in?
            session[:user_id] = nil
            redirect '/'
        else
            redirect '/'
        end
    end

    helpers do

        def logged_in?
            !!current_user
        end

        def current_user
            @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
        end

    end

end