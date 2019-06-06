library(rethinking)
library(dplyr)
library(Hmisc)


library(ggmap)
library(mapproj)
library(DataTaipei)
library(dplyr)



df <- read.csv("201601.txt",
               sep="")

register_google(key = "AIzaSyB15Z9DEJCtKe6BzE6WkkW7qaF20jiThgg", write = TRUE)




map <- get_map(location = 'Taipei', zoom = 12, maptype = "terrain", language = "zh-TW",color="bw")
ggmap(map)



slatlong <- read.csv("station name with lat and long(ver last).csv")
library(stringr)
slatlong$rent_sta<- str_sub(slatlong$rent_sta,15,-1) # trim out "Taiwan" characters

avgtime_data <- read.csv("C:/Users/willy/Desktop/ntu mba/grade 1 semester two/multivariate analysis/QBS group project/avg_time.csv")


# merge avg_time and latlong dataframes
time_lat_and_long <- merge(slatlong,avgtime_data,by.x="rent_sta")
  
ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=time_lat_and_long,color = 'blue')+
  scale_size_continuous(range = c(1,10), 
                        breaks = c(2500, 5000, 7500, 10000,12500,15000)) +labs(size = '使用時間')

#trim out second > 20000 datas

t_clean <-time_lat_and_long[time_lat_and_long$Sec < 20000,]
ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=t_clean)





#plot count
ggmap(map)+geom_point(aes(x=lat,y=long,size=Count),data=time_lat_and_long,color = 'blue')+
  scale_size_continuous(range = c(1,6), 
                        breaks = c(50, 100, 150, 200,250,300)) +labs(size = '借出車數(一月total)')







# 
# #now plot by "return_sta"
# slatlong$return_sta <- station_names
# slatlong$return_sta<- str_sub(slatlong$return_sta,8,-1) # trim out "Taiwan" characters
# time_lat_and_long_2 <- merge(slatlong,avgtime_data,by.x="return_sta")
# t2_clean <-time_lat_and_long[time_lat_and_long$Sec < 20000,]
# 
# 
# ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=t2_clean)
# 



