require 'sinatra'
require 'sinatra/reloader'

# Return index html
get '/' do
  erb :index  
end

# Return the most frequent single word
post '/count' do
  if params[:most].nil? then
    if params[:word].nil? then
      @return_value = params[:text].length
    else
      @str = params[:text]
      @str_ary = @str.split(" ")
      @return_value = @str_ary.group_by { |e| e }.sort_by { |e, v| -v.size }.map(&:first).first
      
    end
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
<<<<<<< HEAD:test_app/app.rb

post '/word' do
  
end
=======
>>>>>>> origin/master:app1/test_app/app.rb
