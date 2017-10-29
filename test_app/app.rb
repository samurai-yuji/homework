require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'sqlite3'


def hash_sort_def(str)
  hash = {}
  str_ary = str.split(" ")
  str_ary.each do |key|
    if hash.has_key?(key) then
        hash[key] += 1
    else
        hash[key] = 1
    end
  end
  return hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }
end


get '/' do
  erb :index  
end

post '/add_to_database' do

  ua = request.env['HTTP_USER_AGENT']
  browser = if ua.include? "MSIE"
    "ie"
  elsif ua.include? "Firefox"
    "firefox"
  elsif ua.include? "Chrome"
    "chrome"
  elsif ua.include? "Opera"
    "opera"
  elsif ua.include? "safari"
    "safari"
  else
    "others"
  end
  
  db = SQLite3::Database.new('test.db')
  db.execute("insert into test (browser,text) values ('#{browser}','#{params[:foo]}')")
  db.close
  
  return browser
end

post '/post' do
  params[:foo].length.to_s
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

post '/browser_graph' do

  wak = "<caption>単語数ランキング</caption><thead><tr><td></td>"

  #hash = {"ie" => 0,"firefox" => 0,"chrome" => 0,"opera" => 0,"safari" => 0,others: 0 }
  chrome_str_ary = []
  others_str_ary = []
  str_ary = []
  
  chrome_str_hash = {}
  others_str_hash = {}
  str_all = []
  
  db = SQLite3::Database.new('test.db')
  db.results_as_hash = true
  db.execute('select * from test') do |row|
    str_ary = row["text"].split(" ")
    str_ary.each do |key|
      unless str_all.include?(key) then
          str_all.push(key)
        end
      end
  end
  
  db.execute('select * from test') do |row|
    chrome_str_ary = row["text"].split(" ")
    if row["browser"] == "chrome" then
      str_all.each do |key|
        if chrome_str_hash.has_key?(key) then
          chrome_str_hash[key] += 1
       else
          chrome_str_hash[key] = 0
        end
      end
    else
     
    end
  end
  db.close
  
  chrome_chars_sort = chrome_str_hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }
  #str_chars_sort = str_hash.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }
 
  def add_elements(wak, tag, close_tag, hash_sort, num)
    hash_sort.each do |value|

      wak += tag
      wak += value[num].to_s
      wak += close_tag
    end
    return wak
  end

  wak = add_elements(wak, "<th>", "</th>", chrome_chars_sort, 0)
  wak += "</tr></thead><tbody><tr><th>単語数</th>\n"
  wak = add_elements(wak, "<td>", "</td>", chrome_chars_sort, 1)
  wak += "</tr></tbody>\n";
  return wak
  #trの中を繰り返す
  
end


post '/bar_graph' do

  hash_sort = hash_sort_def(params[:foo])
  
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


post '/pie_chart' do
  hash_sort = hash_sort_def(params[:foo])
  
  wak = "<caption>単語数ランキング</caption><thead><tr><td></td><th>単語数</th></tr></thead><tbody>"
  
  hash_sort.each do |value|
    wak += "<tr><th>"
    wak += value[0].to_s
    wak += "</th>"
    wak += "<td>"
    wak += value[1].to_s
    wak += "</td></tr>"
  end 
  
  wak += "</tbody>"
  
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