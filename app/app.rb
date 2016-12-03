ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require_relative 'data_mapper_setup'


class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'my secret password'


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
  #require'pry';binding.pry
  redirect'/home'
end

get '/home' do
  erb :'/peeps/home'
end








# start the server if ruby file executed directly
run! if app_file == $0

end
