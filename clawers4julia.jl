#for julia
using Gumbo
using Cascadia
using HTTP
using Dates
using JSON
using Printf

proxy_list = [
    Dict("http"=> "http://35.185.196.38:3128","https"=> "http://35.185.196.38:3128"),
    Dict("http"=> "http://20.205.61.143:80","https"=> "http://20.205.61.143:80")

    # 更多代理...
]

headers = Dict(
    "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    "cookie"     => "over18=1"     
)

#
url="http://stackoverflow.com/questions/tagged/julia-lang"
#status headers body request version
r = HTTP.get("http://stackoverflow.com/questions/tagged/julia-lang",headers=headers,proxies=proxy_list[1])

h = parsehtml(String(r.body))

##HTMLDocument doctype root errors

#CSS 选择器 : id 選擇器 #   ，属性选择器 Selector("input[type='button']")  如果是要用文本nodeText
qs = eachmatch(Selector("div#questions"),h.root)

for i in qs
    length_i=eachmatch(Selector("div.s-post-summary.js-post-summary"), i)

    for k in length_i
            
        votes = nodeText(eachmatch(Selector("span.s-post-summary--stats-item-number"),  k)[1])
        answer=nodeText(eachmatch(Selector(".s-post-summary--stats-item-number"), k)[1])
        href = eachmatch(Selector("a.s-link"), k)[1].attributes["href"] 
        answer=parse(Int, answer) >0
        title = nodeText(eachmatch(Selector("a.s-link"),k)[1])
        @printf("%-5s %-5s %-10s http://stackoverflow.com%s \n", votes , answer , title , href)
        #@printf(votes," ",answer,"[$title](http://stackoverflow.com$href)")
    end
end

eachmatch(Selector("div.s-post-summary.js-post-summary"), qs[1])