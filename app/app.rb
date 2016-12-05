ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'


class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'my secret password'
  register Sinatra::Flash


  helpers do
    def current_user
    @current_user = User.get(session[:user_id])
    end
  end

get '/' do
  "Hello world!"
end

get '/signup' do
  erb :'/users/signup'
end

post '/signup' do
  p params
  @user = User.new(first_name: params[:first_name], surname: params[:surname], username: params[:username], email: params[:email],password: params[:password])
  session[:first_name] = @user.first_name

  if @user.save
    session[:user_id] = @user.id
    redirect to('/home')
  else
    flash.now[:notice] = "Username and/or e-mail have been used already!"
    erb :'/users/signup'
  end
end

get '/signin' do
  erb :'/users/signin'
end

post '/signin' do
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    redirect to('/home')
  else
    flash.now[:notice] = ['The email or password is incorrect']
    erb :'users/signin'
  end
end


get '/home' do
  current_user
  @peeps = Peep.all.reverse.map {|a| [a.content, a.created_at, a.username]}

  erb :'/peeps/home'
end

get '/new_peep' do
  erb :'/peeps/new'
end

post '/peep' do
  current_user
  p params
  peep = Peep.create(:content => params[:peep], :username => @current_user.username)

  @current_user.peeps << peep
  @timestamp = peep.created_at
  @current_user.save

  #require 'pry';binding.pry
  redirect'/home'
end

get '/signout' do
  session[:user_id] = nil
  session[:first_name] = nil
  erb :'/users/signout'
end

# start the server if ruby file executed directly
run! if app_file == $0

end
