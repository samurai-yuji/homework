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

  # Databaseとの接続インターフェース(ドライバ)を作成する
  def get_driver(file)
    db = SQLite3::Database.new(file)
    db.results_as_hash = true
    return db
  end

  # ブラウザごとに単語数を示すハッシュを作成する
  # 単語数0の単語も表示するための全単語の配列も作成する
  def get_hash_array_for_browser(db)
    hash = Hash.new { |h,k| h[k] = {} } # key:ブラウザ名, value:単語数を示すハッシュ
    arr  = [] # 全単語の配列

    db.execute('select * from test') do |row|
      word_cnt = hash[row["browser"]]
      row["text"].split(" ").each do |str|
        unless arr.include?(str) then
          arr.push(str)
        end
        if word_cnt.has_key?(str) then
          word_cnt[str] += 1
        else
          word_cnt[str] = 1
        end
      end
    end

    return hash,arr
  end

  # 単語数0の単語を加える
  def format_hash(hash,arr)
    hash.each do |_,word_cnt| #各ブラウザで単語の順番を揃える
      arr.each do |str|
        unless word_cnt.has_key?(str) then
          word_cnt[str] = 0
        end
      end
    end
  end

  def add_elements(wak, tag, close_tag, word_cnt, flag)
    word_cnt.sort.each do |val|
      wak += tag
      case flag
        when :word then wak += val[0].to_s
        when :cnt  then wak += val[1].to_s
      end
      wak += close_tag
    end
    return wak
  end

  def get_table_html(hash)
    wak = "" # ?
    hash.each_with_index do |(key,val),idx| #表の各行にブラウザ名と単語数を反映させる
      if idx == 0
        wak += "<caption>単語数ランキング</caption><thead><tr><td></td>"
        wak = add_elements(wak, "<th>", "</th>", val, :word)
      else
        wak += "</tr></thead><tbody><tr><th>#{key}</th>\n"
        wak = add_elements(wak, "<td>", "</td>", val, :cnt)
      end
    end
    wak += "</tr></tbody>\n";
	return wak
  end

  db = get_driver('test.db')
  hash,arr = get_hash_array_for_browser(db)
  db.close
  format_hash(hash,arr)
  return get_table_html(hash)

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
