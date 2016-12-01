######################
###Content Analysis###
######################

##This code:
# 1) imports and cleans the raw bill data, 
# 2) pre-processes bill titles for text analysis
# 3) sorts bills into categories with structural topic modeling
# 4) plots the topcic results and their prevalence over time

###1- DATA IMPORTING AND CLEANING###

library(stm)
library(dplyr)

#read the data, merge all Congresses
dat1 <- read.csv("bills9394_API.csv")
dat2 <- read.csv("bills9599_API.csv")
dat3 <- read.csv("bills0004_API.csv")
dat4 <- read.csv("bills0509_API.csv")
dat5 <- read.csv("bills1014_API.csv")
dat <- rbind(dat1, dat2, dat3, dat4, dat5)

#remove irrelevant member info dictionary
dat$sponsor_role <- NULL 
#change date strings into R-readable dates
dat$current_status_date <- as.Date(dat$current_status_date)


###2- PRE-PROCESSING###

#explore data for custom stop words- common labeling words, other non-substantive words to remove
sample(dat$title, 25) #repeated several times
customstop <- c("H.R.", "S. ", "H.J.Res. ", "S.J.Res ", "bill", "resolution", "act", "amend", 
                "extend", "joint", "authorize", "extending", "amendment", "amendments", "expand", 
                "title", "chapter", "amended", "provision", "provisions", "reauthorize", "code", 
                "section", "purpose", "purposes", "request", "authorizing", "requesting", "ensure", 
                "extending", "reauthorization", "sjres", "hjres")


#process text
temp<-textProcessor(documents=dat$title, metadata=dat, customstopwords = customstop)
meta<-temp$meta
vocab<-temp$vocab
docs<-temp$documents
out <- prepDocuments(docs, vocab, meta, lower.thresh = 3) #only words used at least thrice
docs<-out$documents
vocab<-out$vocab
meta <-out$meta
length(meta$current_status_date)

###3- TOPIC MODELING###

#model topics (21 topics b/c there are 21 permanent House and Senate committees, adjust for date)
model <- stm(docs,vocab, 21, prevalence=~s(current_status_date), data=meta, init.type="Spectral")


#explore and visualize topics
labelTopics(model, topics=21)
cloud(model, topic=3)
findThoughts(model, texts=as.character(meta$title), n=200, topics=21)

#assign topic labels using clouds and word frequencies
labels <- c("Relief", "Naming Buildings", "Parks and Historical Sites", "Veterans and Native Americans", 
            "Agriculture and Energy", "Appropriations", "Debt, Tariffs, Military", "Water and Interior", 
            "Administration", "Commemoration and Recognition", "DC Governance", "Adjustments and Extensions", 
            "Executive Agencies and Veterans", "Reauthorizations and Extensions", "Taxation", 
            "Land and Facilities", "Energy and Public Health", "Naming Buildings", "Awareness Holidays",
            "Federal Lands", "Emergencies and Aid")

#estimate effect of date on topic model
prep <- estimateEffect(1:21 ~ s(as.numeric(current_status_date)), model, meta=out$meta, uncertainty="Global")

###4- PLOTTING###

#plot category frequency
plot.STM(model,type="summary",custom.labels=labels,main="")
model$mu


#plot category frequency over time, explore to find interesting things to present 
cdata <- data.frame(seq(min(prep$data[,1]),max(prep$data[,1]), by = "day")) #this works around a bug in the stm package that didn't deal well with dates
plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels[1:3],
                    method="continuous", topics=c(1,2,3))

#select a few for comparison
plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels[c(2,3,19)],
                    method="continuous", topics=c(2,3,19), ylim=c(0,.6), xaxt="n")
axis(1, at=seq(1,20000, 2223), labels=c(1973,1978,1983,1988,1993,1998,2003,2008,2013))

plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels[c(5,6,8)],
                    method="continuous", topics=c(5,6,8), ylim=c(0,.25), xaxt="n")
axis(1, at=seq(1,20000, 2223), labels=c(1973,1978,1983,1988,1993,1998,2003,2008,2013))


###Export plots for presentation
pdf("wordcloud.pdf")
cloud(model, topic=3)
dev.off()

pdf("frequency.pdf")
plot.STM(model,type="summary",custom.labels=labels,main="Topic Frequency")
dev.off()

pdf("effect1.pdf")
plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels[c(2,18,19)],
                    method="continuous", topics=c(2,18,19), ylim=c(0,.6), xaxt="n")
axis(1, at=seq(1,20000, 2223), labels=c(1973,1978,1983,1988,1993,1998,2003,2008,2013))
dev.off()

pdf("effect2.pdf")
plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels[c(5,6,8)],
                    method="continuous", topics=c(5,6,8), ylim=c(0,.25), xaxt="n")
axis(1, at=seq(1,20000, 2223), labels=c(1973,1978,1983,1988,1993,1998,2003,2008,2013))
dev.off()

pdf("effect3.pdf")
plot.estimateEffect(prep, "current_status_date", model = model, labeltype = "custom", custom.labels = labels,
      method="continuous", topics=c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21), ylim=c(0,1), xaxt="n")
axis(1, at=seq(1,20000, 2223), labels=c(1973,1978,1983,1988,1993,1998,2003,2008,2013))
dev.off()

