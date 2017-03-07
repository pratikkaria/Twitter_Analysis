#Code For Twitter Data Scraping using Twitter API


install.packages("twitteR")#Installing twitter package which provides interface to twitter web API
install.packages("ROAuth")#Installing ROAuth package which provides an interface to OAuth 1.0 specification
library("twitteR")#Loading the necessary libraries
library("ROAuth")#Loading the necessary libraries
library("httr")#Loading the necessary libraries
library("xlsx")#Loading the necessary libraries
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")#Download file necessary for handshaking
cred<-AuthFactory$new(consumerKey='XPBxd5NAWF4CCZSNCR72jq5oB',
                      consumerSecret='V6tBzlyJinlE0Qe6NauAQ1CxNOkJSjwE8C21y9MToWJhGdwFyj', 
                      requestURL='https://api.twitter.com/oauth/request_token',
                      accessURL='https://api.twitter.com/oauth/access_token', 
                      authURL='https://api.twitter.com/oauth/authorize')#Create object cred to store authenticated object for later sessions
cred$handshake(cainfo="cacert.pem")#Handshaking occurs in this stage
save(cred, file="twitter authentication.Rdata")#saving object cred on local machine
load("twitter authentication.Rdata")#loading the object cred
country<-read.csv("../CSV/country.csv",header = T)#reading csv file containing names and location of all countries
attach(country)
n<-nrow(country)#counting number of rows
C1<-as.character(Country)
count<-1
flag<-1
datalist=list()#Declaring a blank list
dist<-2000
country1<-as.data.frame(Country)#converting Country to dataframe
for(i in 1:n)#Loop through all the countries
{
  x<-C1[i]
  latitude<-Latitud[i]#extracting the lattitude of a country
  longitude<-Logitud[i]#extracting the longitude of a country
  loc<-paste0(latitude,',',longitude,',',dist,"km")
  statuses<-searchTwitter("#HarryPotter", n=50, lang="en",geocode = loc)#Extracting tweets based on a particular keyword
  tweets.df <- do.call("rbind", lapply(statuses, as.data.frame))#binding all tweets to a single dataframe
  X <- vector(mode="character", length=nrow(tweets.df))
  for(j in 1:nrow(tweets.df))#This loop stores a particular country in vector X.
  {
    X[j]=C1[i]
  }
  tweets.df$Countr1<-cbind(X)
  datalist[[i]]<-tweets.df#Storing dataframe in a list
  count<-count+1
}
big_data = do.call(rbind, datalist)#Doing row-wise bind of the list
write.csv(big_data, file="../CSV/final_data.csv")#Storing the final extracted data
