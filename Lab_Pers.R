#Loading Lab personnel data 
lab <- read_csv("Laboratory Personnel By Country.csv")
lab_data <- as.data.frame(lab)

#Identifying the more complete data set (technicians vs scientists)
sum(is.na(lab_data$`Medical and Pathology Laboratory scientists (number)`))
sum(is.na(lab_data$`Medical and Pathology Laboratory Technicians (number)`))

#Technicians is a more complete data set, so I will proceed with this column 

#Isolating the technicians column 
lab_tech <- select(lab_data, "Country", "Year", "Medical and Pathology Laboratory Technicians (number)")
colnames(lab_tech)[colnames(lab_tech) == "Medical and Pathology Laboratory Technicians (number)"] <- "Technicians"

#Removing Na values for technicians 
lab_nona <- na.omit(lab_tech)

#Changing country column from character to factor
class(lab_nona$Country)
lab_nona$Country <- as.factor(lab_nona$Country)

#Converting country factor to numeric
numeric_trial <- as.numeric(lab_nona$Country)
numeric_added <- cbind(lab_nona, numeric_trial)
numeric <-  numeric_added[ , c("Country", "numeric_trial", "Year", "Technicians")]
colnames(numeric)[colnames(numeric) == "numeric_trial"] <- "Factor" 

#Identifying latest data for each country 
top_year <- numeric %>% group_by(Country) %>% top_n(1, Year)

#Isolating countries for which we have data from the last 5 years 
last_five <- top_year[!top_year$Year <= 2015, ]

matching_lab <- match(last_five$Country, percent_rep$Country)

percent_lab <- percent_rep[c(matching_lab), ]

last_five1 <- last_five

last_five1$Country <- as.character(last_five1$Country)

last_five2 <- last_five1[ , c("Country", "Year", "Technicians")]

#Putting data frames together
bound_lab <- cbind(percent_lab, last_five2$Year, last_five2$Technicians)

colnames(bound_lab)[colnames(bound_lab) == "last_five2$Year"] <- "Year"
colnames(bound_lab)[colnames(bound_lab) == "last_five2$Technicians"] <- "Technicians"
colnames(bound_lab)[colnames(bound_lab) == "Percent Reported" ] <- "Perc_Reported"

#Plotting the data 
plot <- ggplot(bound_lab, aes(x = Technicians, y = Perc_Reported)) + geom_point()

bound_lab

plot(bound_lab$Difference, bound_lab$Technicians)
     