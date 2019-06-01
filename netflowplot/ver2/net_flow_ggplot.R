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



slatlong <- read.csv("station name with lat and long(ver last).csv")
library(stringr)

slatlong$rent_sta<- str_sub(slatlong$rent_sta,15,-1) # trim out "Taiwan Taipei" characters


#sum(net_in)by date
flow_data <- read.csv("hour_data.csv")

library(data.table)
byday_flow <- data.table(flow_data)
byday_flow[, dayNetIn := sum(net_in), by= c("date","station_id")]

byday_flow <- unique(byday_flow, by = c("date","station_id"))


#try to link rent_sta to rent_id from orignal data

sta_to_id <- unique(data.table(df), by = 'rent_id')
sta_to_id = sta_to_id[,c(1,2)]

#link byday_flow id to station

colnames(byday_flow)[4] <- "rent_id"
byday_flow_sta <- merge(byday_flow,sta_to_id)


# merge avg_time and latlong dataframes
flow_lat_and_long <- merge(byday_flow_sta,slatlong,by="rent_sta")

flow_lat_and_long_red <- subset(flow_lat_and_long, dayNetIn>=0)
flow_lat_and_long_blue <- subset(flow_lat_and_long, dayNetIn<0)



#這邊的plot會重疊太多  因為30天每一站點各有30個靜流量
ggmap(map)+geom_point(mapping = aes(x=lat,y=long,size=dayNetIn,color='red'),data=flow_lat_and_long_red)+
  geom_point(mapping = aes(x=lat,y=long,size=dayNetIn,color='blue'),data=flow_lat_and_long_blue)+
  scale_size_continuous(range = c(1, 8), 
                      breaks = c(25, 50, 75, 100)) +labs(size = '淨流量')





library(ggplot2)
library(gganimate)
library(ggmap)
library(maps)
library(gifski)

# Order data
flow_lat_and_longO<- flow_lat_and_long[with(flow_lat_and_long, order(date))]
flow_lat_and_long_redO<- flow_lat_and_long_red[with(flow_lat_and_long_red, order(date))]
flow_lat_and_long_blueO <- flow_lat_and_long_blue[with(flow_lat_and_long_blue, order(date))]


# Build plot
library(scales)
g<-ggmap(map)+geom_point(mapping = aes(x=lat,y=long,size=3,color=dayNetIn),data=flow_lat_and_longO)+ 
  scale_colour_gradientn(colours = c( "red", "yellow", "white", "lightblue", "darkblue" ),
                         values = scales::rescale(c( 100, 30, 0, -30, -100)))+ 
  transition_time(as.Date(flow_lat_and_longO$date))+labs(title = paste("Day", "{round(frame_time,0)}"))

animate(g,fps=4)
anim_save("netflow.gif", g)


# gRed<- ggmap(map)+geom_point(mapping = aes(x=lat,y=long,size=dayNetIn,color='red'),data=flow_lat_and_long_redO)+
#   transition_time(as.Date(flow_lat_and_long_redO$date))+labs(title = paste("Day", "{round(frame_time,0)}")) +
#   scale_fill_gradientn(colours=c("blue","cyan","white", "yellow","red"), 
#                        values=rescale(c(-1,0-.Machine$double.eps,0,0+.Machine$double.eps,1)))
# 
# animate(gRed,fps=2)
# 
# gBoth<- ggmap(map)+geom_point(mapping = aes(x=lat,y=long,size=dayNetIn,color='red'),data=flow_lat_and_long_redO)+
#   transition_time(as.Date(flow_lat_and_long_redO$date))+labs(title = paste("Day", "{round(frame_time,0)}"))
#   geom_point(mapping = aes(x=lat,y=long,size=dayNetIn,color='blue'),data=flow_lat_and_long_blueO)+
#   transition_time(as.Date(flow_lat_and_long_blueO$date))+labs(title = paste("Day", "{round(frame_time,0)}"))
# 
# animate(gBoth,fps=2)


