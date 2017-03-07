install.packages("ggplot2")
install.packages("rworldmap")
install.packages("rgeos")
library(RColorBrewer)
library(ggplot2)
library(rworldmap)
library(maptools)
library(maps)
library(plyr)
setwd("C://Users//pc//Desktop//BigData//R") #fetch csv file from location
tweetsdata<-read.csv("Retweets.csv")
attach(tweetsdata)
data(wrld_simpl)
plot(wrld_simpl, 
     col = c(gray(.80), "red")[grepl("^U", wrld_simpl@data$Country) + 1])
names(tweetsdata)<-c("region","freq") 
names(tweetsdata)
tweetsdata$freq[tweets$freq==0] <- NA
#load world geographical data
world <- map_data("world2")
#Delete Antarctica because no realistic tweets coming from that region
world <- subset(world,region!="Antarctica")
#map region from the list provided in csv file and corresponding number of tweets occurring from that region
world$tweets <- tweetsdata$freq[match(world$region,tweetsdata$region,nomatch=NA)]
#generate map plotted using the regions of the world and the tweets generated from each region
map <- qplot(long, lat, data = world, group = group,fill=tweets,geom ="polygon",ylab="",xlab="")
map
map + scale_fill_gradient(name="Number of\nTweets", breaks = c(5,10,15,20,25,30,35,40,45,50))

