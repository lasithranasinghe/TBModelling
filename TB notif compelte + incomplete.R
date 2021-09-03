#Manipulating and simplifying the TB notification data 
#25 Aug 2021 
View(TBnotif)  
TBnot1 <- as.data.frame(TBnotif)
filter_1 <- select(TBnot1, "country", "year", "newrel_m014", "newrel_f014") #focusing on 0-14 age group only
filter_2 <- filter(filter_1, year == 2019) #focusing on data for 2019 only 
TB014 <- filter_2
completeTB <- TB014[complete.cases(TB014),] #pulling out the complete data sets 
incompleteTB <- TB014[complete.cases(TB014) == FALSE,] #pulling out the incomplete data sets 
TBtotal014 <- completeTB %>% mutate("total_014"=newrel_m014 + newrel_f014) #putting together male and female data
all_sexes <- select(TBtotal014, "country", "total_014")
colnames(all_sexes)[colnames(all_sexes) == "country"] <- "Country"
colnames(all_sexes)[colnames(all_sexes) == "total_014"] <- "Reported"