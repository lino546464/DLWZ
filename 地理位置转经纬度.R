library(data.table)
add = read.csv('C:\\Users\\LiNing\\Desktop\\大论文\\bin\\data\\江苏省.csv')
add = data.table(add)
add = add[,.(省,市,县.区,地理位置)]
add = as.data.frame(add)
add_s = as.character(add[,1])
add_shi = as.character(add[,2])
add_xian = as.character(add[,3])
add_di = as.character(add[,4])
address = paste(add_s,add_shi,add_xian,add_di,sep = "")

head(address)

address
#建立备用向量，包括空向量及百度地图api秘钥
baidu_lng <- c()
baidu_lat <- c()
ak <- 'iDThqXy4gonGPbdARK1ofpwaIXGgiU4w'     #百度地图api的秘钥，需自己申请
#加载包
library(rjson)
library(RCurl)
#循环解析过程
for (location in address) {
  #生成规则的url地址(具体参数可参考Geocoding API文档)
  url <- paste('http://api.map.baidu.com/geocoder/v2/?address=',location,'&output=json&ak=',ak,'&callback=showLocation',sep="")
  #利用URLencode()转换为可解析的URL地址
  url_string <- URLencode(url)
  #通过readLines读取URL地址，并解析JSON格式的结果
  json<- readLines(url_string, warn=F,encoding = "UTF-8")
  #json = getURL(url_string,httpheader=myheader)
  json
  geo <- fromJSON(substr(json,regexpr('\\(',json)+1,nchar(json)-1))
                  #在解析结果中提取经纬度
                  lng<-geo$result$location$lng
                  lat<-geo$result$location$lat
                  #存储到已经建好的字段中
                  baidu_lng <- c(baidu_lng,lng)
                  baidu_lat <- c(baidu_lat,lat)
}
#整理结果
result <- data.frame(address=address,longitude=baidu_lng,latitude=baidu_lat)
head(result)
write.csv(result,"C:\\Users\\LiNing\\Desktop\\大论文\\数据\\经纬度\\江苏省.csv")

