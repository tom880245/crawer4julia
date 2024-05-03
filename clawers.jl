#
using Dates
using PyCall
using JSON
ENV["PYTHON"]=raw"C:\Users\Administrator\AppData\Local\Programs\Python\Python312\python.exe"
function pyimport_(input::String)
    @eval using Dates
    function install_package(input2::String)
        run(`cmd /C pip install $(input2)`)
        sleep(0.2)
    end
    try

        @eval pyimport(input)
    catch
        println("$input is not installed. Installing...")
        install_package(input)
        @eval import Pkg
        Pkg.build("PyCall")
        @eval using PyCall
        pyimport(input)
    end
end


url="https://www.ptt.cc/bbs/Gossiping/index.html"
nexturl="https://www.ptt.cc"
b="d/cm/dd"
requests=pyimport_("requests")
bs4=pyimport_( "bs4")
headers = Dict(
    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "cookie"     => "over18=1"     
)

r = requests.get(url,headers=headers)

soup = bs4.BeautifulSoup(r.text, "html.parser")

#列出人氣>10的 標題 人氣

#first_id = row.find("td", class_="form-headup-c")
# title = soup.select("div.title a")
# number= soup.select("div.nrec span")
#長度不一樣  所以只能用FIND
rows = soup.find_all("div",class_="r-ent")

function vectorstring2string(data)
    f=data|>PyCall.pybuiltin("list")
    return f[1]
end
#創建字典
struct ValuePair
    value1::String
    value2::String
end

let title2dict=Dict(),i=0
#文件路徑
#輸出 標題 人氣 網址

for row in rows
    i+=1
    title,popularity,tempurl="","",""
   
    find_tempurl = row.find("div", class_="title").find("a").get("href")
    tempurl=nexturl*find_tempurl
    popularity=row.find("div",class_="nrec").text
    popularity=="" ? popularity="無" : nothing
    title=string(i)*"."*strip(row.find("div",class_="title").text,'\n')
    #println(title," : " ,popularity, "網址" ,tempurl )
    try get!(title2dict,title,ValuePair(popularity,tempurl))
    catch 
        println("錯誤")
    end

end

end

# pattern = r"(\w+)"
# matches=[]
# for i in picdraW
#     push!(matches,first(collect(eachmatch(r"\b[A-Za-z\d、-]+", i))).match)
# end

# Classification_A=String[]
# Classification_D=String[]
# Classification_S=String[]
# Classification_number=String[]
# patternA=r"A.*"
# patternD=r"D.*"
# patternS=r"S.*"

# for i in matches
#     match(patternA,i) != nothing ? push!(Classification_A,i) :
#      (match(patternD,i) != nothing ? push!(Classification_D,i) : 
#      (match(patternS,i) !=nothing  ? push!(Classification_S,i) :
#      push!(Classification_number,i)))
# end





length(rows)

length(title)

output=Dict("test" => 212 ,"test2"=>3232)
pairs(a)
for i  in keys(output)
   println("標題 :",i,"人氣 :" , get(output,i,"_") )
end

appleDict("aa"=>[454,54])