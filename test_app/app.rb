require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index  
end

post '/count' do
  if params[:most].nil? then
    @return_value = params[:text].length
  else
    @input_value = params[:text]
    @most_many_char_count = 0
    @input_value.chars { |ch|
      @input_value_char_count = @input_value.count(ch)
      
    if @most_many_char_count < @input_value_char_count then
      @most_many_char_count = @input_value_char_count
      @return_value = ch
    end
      
    }
  end

  erb :count
end