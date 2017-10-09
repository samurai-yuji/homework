require 'sinatra'
require 'sinatra/reloader'
require 'pry'

get '/' do
  erb :index  
end

post '/post' do
  data = params[:foo].length.to_s
end

post '/most' do
input_value = params[:foo]

    most_many_char_count = 0
    input_value_char_count = 0
    input_value.chars { |ch|
 
      input_value_char_count = input_value.count(ch)
          
    if most_many_char_count < input_value_char_count then
      most_many_char_count = input_value_char_count
      content_type :text
      @data = ch
    end
      
    }
    return @data
end

post '/text' do

  hash = {}
  str = params[:foo]
  str_ary = str.split(" ")
  str_ary.each do |key|
    if hash.has_key?(key) then
        hash[key] += 1
    else
        hash[key] = 1
    end
  end
  hash_sort = hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }

  
  wak = "<caption>単語数ランキング</caption><thead><tr><td></td>"


  def add_elements(wak, tag, close_tag, hash_sort, num)
    hash_sort.each do |value|
      wak += tag
      wak += value[num].to_s
      wak += close_tag
    end
    return wak
  end

  wak = add_elements(wak, "<th>", "</th>", hash_sort, 0)
  wak += "</tr></thead><tbody><tr><th>単語数</th>\n"
  wak = add_elements(wak, "<td>", "</td>", hash_sort, 1)
  wak += "</tr></tbody>\n";

  return wak
end


get '/mohan' do
content=<<'EOS'
<html> 
  <head> 
    <meta charset="utf-8"> 
    <title>test</title> 
    <script type=text/javascript> 
      function ajax(){ 
        var req = new XMLHttpRequest(); 
        req.onreadystatechange = function() { 
          console.log(this); 
          var res = document.getElementById("disp"); 
        if(this.readyState == 4){ 
          if(this.status == 200){ 
            res.innerHTML = this.responseText; 
          } 
        }else{ 
          res.innerHTML = "通信中..." + req.readyState; 
        } 
      } 
      req.open("POST",'/mohan', true); 
      req.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8'); 
      req.send('sentense='+encodeURIComponent(document.getElementById("sentense").value)); 
      //req.send(null); 
      } 
    </script> 
  </head> 
  <body> 
  <input type=textarea id="sentense"> 
  <input type=submit value="送信" onclick='ajax()'> 
  <div id="disp"></div> 
  </body> 
</html> 
EOS

end 

post '/mohan' do 
p params[:sentense] 
"<p>#{params[:sentense].split().size()}</p>" 
end