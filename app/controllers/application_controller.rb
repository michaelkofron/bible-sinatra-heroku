require './config/environment'

class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'

        use Rack::Session::Cookie, :key => 'rack.session',
                           #:domain => 'foo.com',  
                           :path => '/',
                           :expire_after => 120, # In seconds
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
        if params[:username] == "" || params[:password] == ""
            redirect '/signup'
        elsif User.find_by(username: params[:username])
            redirect '/signup!'
        else
            @user = User.create(username: params[:username], password: params[:password])
            session[:user_id] = @user.id
            redirect '/search'
        end
    end

    get '/signup!' do
        if !logged_in?
            erb :'users/newredo'
        else
            redirect '/search'
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
            redirect '/login'
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

        def log_in(email, password)
            user = User.find_by_id(id: session[:user_id])

            if user && user.authenticate(password)
                session[:user_id] = user.id
            else
                redirect '/login'
            end
        end

        def current_user
            @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
        end

    end

end