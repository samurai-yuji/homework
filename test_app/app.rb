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
      
      #count()は使わず、一つずつ単語をカウントしながらhashを完成させるように修正してください。
      #max()は使わず、sort()を使ってください。
      #単語の頻度数のベスト３を返してください、という要件が追加になっても対応できるようにしてください
      
      @hash = {}
      @hash_sort = {}
      @return_value = ""
      @str = params[:text]
      @str_ary = @str.split(" ")
      @str_ary.each do |key|
        unless @hash.has_value?("#{key}") then
          @hash["#{key}"] = @hash["#{key}"].to_i + 1
          @hash_sort = @hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }
        end
      end
      count = 1
      @hash_sort.first(3).each do |value, key|
        @return_value = @return_value + count.to_s + "位：" + value + "<br />"
        count.to_i
        count = count + 1
      end
        
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