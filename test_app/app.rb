require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index  
end

get '/count' do
  @mojisuu = params[:num].length
  erb :count
end