library(rethinking)
library(dplyr)
library(ggmap)




df <- read.csv("C:/Users/willy/Desktop/ntu mba/grade 1 semester two/multivariate analysis/QBS group project/201601.txt",
               sep="")


#TO MAKE SURE THIS GOOGLEMAP TO FIND THE RIGHT PLACE, I ADD TAIWAN FOR EACH STATION NAME
df2 <- df
df2$rent_sta <- lapply(df2$rent_sta, function(x) paste("Taiwan Taipei", x, sep = " "))





#find all station names in data and its lat and long
station_names <- unique(df2$rent_sta)
#lat_and_long <- geocode('Taiwan Taipei Xingya Jr. High School')
lat_and_long = data.frame()



for (i in station_names){
  lat_and_long <- rbind(lat_and_long,geocode(i)) # 這邊還是有可能googlemap抓錯經緯度，估計是中文轉英文站點問題，我棄療
}

#s_lat_and_long為一個有rent_sta跟其相關之經緯度的dataframe
s_lat_and_long = data.frame(matrix(ncol = 3, nrow = 0))
x <- c("rent_sta","lat","long")
colnames(s_lat_and_long) <- x

count <- 1
# record each stattion with its lat and long 
for (i in station_names){
  s_lat_and_long[count,1] <- i
  s_lat_and_long[count,2] <- lat_and_long[count,1] 
  s_lat_and_long[count,3] <- lat_and_long[count,2]
  count <- count+1
}


write.table(s_lat_and_long,file="station name with lat and long ver2.csv",sep=",",row.names = F)
