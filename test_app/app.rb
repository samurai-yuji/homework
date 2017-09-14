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
      @return_value = {}
      @str = params[:text]
      @str_ary = @str.split(" ")
      #@return_value = @str_ary.group_by { |e| e }.sort_by { |e, v| -v.size }.map(&:first).first
      
      #eachループでhashを完成させて下さい。ループの後でhashをsortして答えを取得してください。また、アットマークの意味を考えて実装して下さい。
      
      @str_ary.each do |key|
        value = @str_ary.count(key)
        @hash.store(key,value)
      end
        @hash= @hash.max{ |x, y| x[1] <=> y[1] } 
        @return_value = @hash[0]
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