
#SCOPE

The objective is to map the relative demographically segregated interest generated over social media regarding a particular topic, as found in the frequency of use of a set of hashtags on Twitter. For the purpose of this project, we will use analytics to find interest generated about the launch of “Harry Potter and the Cursed Child” – the eighth book in the hugely successful Harry Potter series by J.K. Rowling. 
By searching and analysing based on specific hashtags - #CursedChild, #HarryPotter, #ChosenOne, #JKRowling and #Potterhead – we will be able to narrow down to the generic interest groups relating to the launch of the book. The data taken will involve tweets that have been posted since the book was officially launched.
Using this information, we have to categorize tweets by country, spanning all countries in the world where there have been tweets about the event. The final objective is to plot the frequency of tweets from each country, thus determining which nations generate maximum interest and which show lukewarm response.

#STEPS OF EXECUTION

o	An application is created in twitter in order to get the tokens to fetch real time twitter data.
o	The twitteR package is installed in R.
o	Connection is made with the Twitter API using the access tokens.
o	Twitter data is scraped from the API.
o	The data frame obtained is stored in a .csv file.
o	The .csv file is stored in HDFS (Hadoop Distributed File System) as input file /input 
o	The /input file is loaded in pig.
o	The tuples are fetched and stored in a relation.
o	The number of tweets and retweets are calculated and stored in 2 different relations in the form of bags. The bags in turn contain tuples corresponding to each country.
o	The relations are sent back to HDFS and stored.
o	The /output file in HDFS is brought into WINDOWS and stored in a .csv file.
o	The ‘rworldmap’ and ‘ggplot2’ packages are installed in R.
o	The data points are plotted on a world map using the ‘rworldmap’ library.
o	The final output of the project is generated which contains two world maps, one of which indicates number of tweets in different countries of the world while the other indicates number of re-tweets for the same.

#CODE EXAMPLE
		    
Run the following code in R
1.	Connecting with twitter API by providing the necessary authentication tokens and scraping data by providing the geocode (latitude and longitude) as to specify a region boundary within which tweets are to be fetched:

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")
cred<-AuthFactory$new(consumerKey='XPBxd5NAWF4CCZSNCR72jq5oB',               consumerSecret='V6tBzlyJinlE0Qe6NauAQ1CxNOkJSjwE8C21y9MToWJhGdwFyj',              requestURL='https://api.twitter.com/oauth/request_token',                       accessURL='https://api.twitter.com/oauth/access_token',                        authURL='https://api.twitter.com/oauth/authorize')
cred$handshake(cainfo="cacert.pem")
save(cred, file="twitter authentication.Rdata")
load("twitter authentication.Rdata")
statuses <- searchTwitter(keyword, n=10000, lang="en",sinceID = NULL, geocode="28.37,77.13,2250km",retryOnRateLimit=10)
2.	Collecting the details about the latitudes and longitudes of the respective countries followed by collection of tweets 50 at a time to avoid “Time Out” error and storing in a .cvs file:

for(i in 60:100)
{
 				 x<-C1[i]
 				 latitude<-Latitud[i]
 				 longitude<-Logitud[i]
 				 loc<-paste0(latitude,',',longitude,',',dist,"km")
statuses<-searchTwitter("/#HarryPotter", n=50, lang="en",geocode = loc)
 				 tweets.df <- do.call("rbind", lapply(statuses, as.data.frame))
 				 X <- vector(mode="character", length=nrow(tweets.df))
  				for(j in 1:nrow(tweets.df))
  				{
    					X[j]=C1[i]
 				 }
 				 tweets.df$Countr1<-cbind(X)
 				 datalist[[i]]<-tweets.df
   				 count<-count+1
}
big_data = do.call(rbind, datalist)
class(big_data)
write.csv(big_data, file="FINAL.csv")
		
Run the following code in Pig (Hadoop)
3.	Filtering of tweets according to the ones which have been tweeted and the ones which have been retweeted using the following commands:

tweet = LOAD '/tweet2' USING PigStorage(',') as (text:chararray, id:int, screenName:chararray, retweetCount:int, isRetweet:boolean, Countr1:chararray);
tweet_data = GROUP tweet BY Countr1;
count1= foreach tweet_data generate group, COUNT($1) as cnt,$1;
m1= foreach count1{
			row= FILTER $2 BY(text=='1');
			generate flatten(row);
			};
countr = GROUP m1 BY Countr1;
count_final= foreach countr generate group, COUNT($1) as cnt,$1;
STORE count_final INTO '/op1' using PigStorage(',');

Run the following code in R
4.	In order to plot the number of tweets and retweets on a world graph, the following code is used:

tweetsdata<-read.csv("Retweets.csv")
attach(tweetsdata)
data(wrld_simpl)
plot(wrld_simpl, 
     			col = c(gray(.80), "red")[grepl("^U", wrld_simpl@data$Country) + 1])
mapDevice('x11')
spdf     <-joinCountryData2Map(tweets, joinCode="NAME", nameJoinColumn="Country")
mapCountryData(spdf, nameColumnToPlot="No of Tweets", catMethod="fixedWidth")
names(tweetsdata)<-c("region","freq")
names(tweetsdata)
change 0's to NA
tweetsdata$freq[tweets$freq==0] <- NA
load world data
world <- map_data("world2")
Delete Antarctica
world <- subset(world,region!="Antarctica")
world$tweets <- tweetsdata$freq[match(world$region,tweetsdata$region,nomatch=NA)]
map <- qplot(long, lat, data = world, group = group,fill=tweets,geom ="polygon",ylab="",xlab="")
map
map + scale_fill_gradient(name="Number of\nTweets", breaks = c(5,10,15,20,25,30,35,40,45,50))

#INSTALLATION

1.	R software and Rstudio

•	Go to  http://ftp.heanet.ie/mirrors/cran.r-project.org and download R for Windows 32/64 bit according to the configurations you have.
•	Go to https://www.rstudio.com/products/rstudio/ and download Rstudio according to the configurations.
•	Start R and use the command install.packages("<package name>") for installing the required packages and library("<library name>") while using the library files each time they are being used.
•	Set the directory in which you are going to work by using the command setwd("C://Users//pc//Desktop//BigData//R").

2.	Twitter Account and connection with API

•	You have already installed R and are using RStudio.
•	In order to extract tweets, you will need a Twitter application and hence a Twitter account. If you don’t have a Twitter account, please sign up.
•	Use your Twitter login ID and password to sign in at Twitter Developers.
•	Create a Twitter Application.
•	Click on create access token button under your application.
•	Note the values of consumer key and consumer secret and keep them handy for future use. You should keep these secret. If anyone was to get these keys, they could effectively access your Twitter account.
•	Follow the code given above to make connection with Twitter API.
3.	Hadoop and Pig

//Installing Hadoop:
wget http://mirrors.sonic.net/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
//Untar the hadoop tar file
tar xvzf hadoop-2.6.0.tar.gz
Change the hadoop directory name
mv hadoop-2.6.0 hadoop
// Installing Vim editor
sudo apt-get install vim
// Checking the JAVA_HOME installation path,
update-alternatives --config java
// Open the .bashrc file & paste the following Hadoop variables
ls -a
vim .bashrc

HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export HADOOP_INSTALL_PATH=/home/hdpuser/hadoop
export PATH=$PATH:$HADOOP_INSTALL_PATH/bin
export PATH=$PATH:$HADOOP_INSTALL_PATH/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL_PATH
export HADOOP_COMMON_HOME=$HADOOP_INSTALL_PATH
export HADOOP_HDFS_HOME=$HADOOP_INSTALL_PATH
export YARN_HOME=$HADOOP_INSTALL_PATH
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL_PATH/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL_PATH/lib"
HADOOP VARIABLES ENDS

// Sourcing the .bashrc file after adding the newly created content

source .bashrc

•	We need to edit the hadoop-env.sh file and set the JAVA_HOME variable. We need to navigate to hadoop/etc/hadoop directory and include JAVA_HOME.

cd hadoop/etc/Hadoop
vim hadoop-env.sh

// Include the following variable in hadoop-env.sh file
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

•	The hadoop/etc/hadoop/core-site.xml file can be used to override the default settings that hadoop starts with.
vim core-site.xml
// Configuration information
<configuration>
 <property>
  <name>hadoop.tmp.dir</name>
  <value>/home/hdpuser/temp/hadoop/tmp</value>
<description>This will contain temporary directories   </description>
 </property>
 <property>
  <name>fs.default.name</name>
  <value>hdfs://localhost:54310</value>
  <description>The default Name Node location</description>
 </property>
</configuration>


•	We will configure the mapred-site.xml to pass the job tracker port

cp mapred-site.xml.template mapred-site.xml
vim mapred-site.xml
// Configuration information
<configuration>
 <property>
  <name>mapred.job.tracker</name>
  <value>localhost:54311</value>
  <description> Job Tracker Port</description>
 </property>
</configuration>

•	We will create the directories for Name Node & Data Node. We will also provide the necessary permissions.

sudo mkdir -p /home/hdpuser/temp/hadoop/hdfs/namenode
sudo mkdir -p /home/hdpuser/temp/hadoop/hdfs/datanode
sudo chown -R hdpuser:hdp /home/hdpuser/temp/hadoop/


•	We will configure the hdfs-site.xml to include the newly created Name Node and Data Node directories.

vim hdfs-site.xml

// Configuration information
<configuration>
 <property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.
The actual number of replications can be specified when the file is created.
The default is used if replication is not specified in create time.
  </description>
 </property>
 <property>
   <name>dfs.namenode.name.dir</name>
<value>file:/home/hdpuser/temp/hadoop/hdfs/namenode</value>
 </property>
 <property>
<name>dfs.datanode.data.dir</name>
<value>file:/home/hdpuser/temp/hadoop/hdfs/datanode </value>
</property>
</configuration>

•	We can format the Name Node & start the single node cluster, All the daemons are running in the same VM.

hadoop namenode -format
// Starting all the Hadoop daemons
go to bin folder in hadoop
start-all.sh
jps
		//installation of PIG
•	Download the lates version of pig eg: pig-0.15.0.tar.gz
•	Create a directory and extract the downloaded .tar fileExtract the downloaded tar files as shown below.
$mkdir Pig
$cd Downloads/
$tar zxvf pig-0.15.0.tar.gz
$ mv pig-0.15.0-src.tar.gz/* /home/Hadoop/Pig/

•	Configure Apache Pig
After installing Apache Pig, we have to configure it. To configure, we need to edit two files − bashrc and pig.properties.

.bashrc file
In the .bashrc file, set the following variables –
PIG_HOME folder to the Apache Pig’s installation folder,
PATH environment variable to the bin folder, and
PIG_CLASSPATH environment variable to the etc (configuration) folder of your Hadoop installations (the directory that contains the core-site.xml, hdfs-site.xml and mapred-site.xml files).
export PIG_HOME = /home/Hadoop/Pig
export PATH  = PATH:/home/Hadoop/pig/bin
export PIG_CLASSPATH = $HADOOP_HOME/conf

#MOTIVATION

Using this project, we can understand the demographic reach of any publication to analyse various variables that can help us understand the importance of the publications. It can further be utilised to improvise the strategies of marketing the publications to increase readability, sales and other necessary requirements for the public to like the publication better.
The world is becoming data driven. Each and every decision are now taken on data from stock markets to the machines that stalk us. The data generated is growing exponentially. With this data we can also develop great solutions around the data. Dependency of variables on data increases the probability of taking better decisions and many problem statements can be designed from the data and solutions are also generated from the same.

#CONTRIBUTORS

1.	Arjyak Bhattacharya (arjyakonline@gmail.com )
2.	Pratik Karia (pratikkaria96@gmail.com )
3.	Anuja Ghosh (anujaghosh6@gmail.com)







