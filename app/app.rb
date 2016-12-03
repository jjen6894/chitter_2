ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require_relative 'data_mapper_setup'


class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'my secret password'

  helpers do
    def current_user
    @current_user ||= User.get(session[:user_id])
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
  user = User.create(first_name: params[:first_name], surname: params[:surname], email: params[:email],password: params[:password])
  session[:user_id] = user.id
  session[:first_name] = user.first_name

  redirect'/home'
end

get '/signin' do
  erb :'/users/signin'
end

post '/signin' do
 p params
 redirect'/home'
end


get '/home' do
  current_user
  @peeps = Peep.all.map {|a| a.content}
  erb :'/peeps/home'
end

get '/new_peep' do
  erb :'/peeps/new'
end

post '/peep' do
  current_user
  p params
  peep = Peep.create(:content => params[:peep])
  #require'pry';binding.pry
  redirect'/home'
end


# start the server if ruby file executed directly
run! if app_file == $0

end
