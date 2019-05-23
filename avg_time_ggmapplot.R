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




map <- get_map(location = 'Taipei', zoom = 12, maptype = "roadmap", language = "zh-TW")
ggmap(map)



slatlong <- read.csv("station name with lat and long.csv")
library(stringr)
slatlong$rent_sta<- str_sub(slatlong$rent_sta,8,-1) # trim out "Taiwan" characters

avgtime_data <- read.csv("C:/Users/willy/Desktop/ntu mba/grade 1 semester two/multivariate analysis/QBS group project/avg_time.csv")


# merge avg_time and latlong dataframes
time_lat_and_long <- merge(slatlong,avgtime_data,by.x="rent_sta")
  
ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=time_lat_and_long)

#trim out second > 20000 datas

t_clean <-time_lat_and_long[time_lat_and_long$Sec < 20000,]
ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=t_clean)



#now plot by "return_sta"
slatlong$return_sta <- station_names
slatlong$return_sta<- str_sub(slatlong$return_sta,8,-1) # trim out "Taiwan" characters
time_lat_and_long_2 <- merge(slatlong,avgtime_data,by.x="return_sta")
t2_clean <-time_lat_and_long[time_lat_and_long$Sec < 20000,]


ggmap(map)+geom_point(aes(x=lat,y=long,size=Sec),data=t2_clean)



write.table(s_lat_and_long,file=".csv",sep=",")
