require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index  
end

post '/count' do
  if params[:most].nil? then
    if params[:word].nil? then
      @return_value = params[:text].length
    else
      @hash = {}
      @max = 0
      @str = params[:text]
      @str_ary = @str.split(" ")
      #@return_value = @str_ary.group_by { |e| e }.sort_by { |e, v| -v.size }.map(&:first).first
      
      @str_ary.each do |value|
        @key = @str_ary.count(value)
        
        if @max < @key then
          @max = @key
          @hash.store(@key,value)
        end
      end
      
      @hash = @hash.max
      @return_value = @hash[1]
      
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

post '/word' do
  
end