View(TBburden) #data direct from WHO 
TBburden <- read_csv("TBburden.csv")

#isolating the important data
firstfilter <- TBburden %>% select(country, age_group, sex, best, lo, hi)

#focusing on age group 0-14
secondfilter <- filter(firstfilter, age_group == "0-14") 

#combining the range into one column
burdensummary <- unite(secondfilter, "range", lo, hi, sep = "-") 

#combining sexes
allcases <- burdensummary %>% filter(sex == "a") 

#removing countries for which there is incomplete notification data
column_match <- allcases[-c(4, 5, 6, 29, 38,46, 48, 53, 57, 59, 73, 81,
                            107, 125, 128, 133, 136, 163, 175, 193, 199), ] 

#cutting down to include only country and estimated
country_burden_only <- select(column_match, "country", "best") 

#renaming estimated column
colnames(country_burden_only)[colnames(country_burden_only) == "best"] <- "Estimated" 

#renaming country column
colnames(country_burden_only)[colnames(country_burden_only) == "country"] <- "Country" 

#adding reported column from TB notif
Final_Data <- cbind(country_burden_only, all_sexes$Reported) 

#renaming reported column
colnames(Final_Data)[colnames(Final_Data) == "all_sexes$Reported"] <- "Reported" 

#adding column to summarise difference 
summary_data_014 <- mutate(Final_Data, Difference = Estimated - Reported)  

#arranging in highest to lowest difference order 
ordered_data_014 <- arrange(summary_data_014, -Difference) 

#expressing reported number as percentage of expected (IMPORTANT DF)
percent_rep <- mutate(ordered_data_014, "Percent Reported" = (Reported/Estimated) * 100)

#adding a continent column and arranging by continent 
continent <- countrycode(sourcevar = summary_data_014$Country, origin = "country.name", destination = "continent")
matrix_continent <- as.matrix(continent)
add_continent <- cbind(summary_data_014, matrix_continent)
colnames(add_continent)[colnames(add_continent) == "matrix_continent"] <- "Continent"
rearrange_cols <- add_continent[, c("Country", "Continent", "Estimated", "Reported", "Difference")]
by_continent <- arrange(rearrange_cols, Continent)

#grouping by continent
Africa_Only <- filter(by_continent, Continent == "Africa") %>% arrange(-Difference)
Asia_Only <- filter(by_continent, Continent == "Asia") %>% arrange(-Difference)
Europe_Only <- filter(by_continent, Continent == "Europe") %>% arrange(-Difference)
Americas_Only <- filter(by_continent, Continent == "Americas") %>% arrange(-Difference)
Oceania_Only <- filter(by_continent, Continent == "Oceania") %>% arrange(-Difference)
final_continent <- rbind(Africa_Only, Asia_Only, Europe_Only, Americas_Only, Oceania_Only)