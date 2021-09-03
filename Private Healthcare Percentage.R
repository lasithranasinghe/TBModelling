#Loading data
data <- read_csv("Percentage Private Healthcare.csv", skip = 1)

#Isolating most recent data only 
data_2018 <- select(data, "Country", "2018")

#Check for matching 
matched_data <- match(data_2018$Country, difference_$Country)
matched_nona <- na.omit(matched_data)
vector_nona <- as.vector(matched_nona)

#Keeping matched data only in the difference table
matched_difference <- difference_[c(vector_nona), ]
arranged_diff <- arrange(matched_difference, Country)

#Keeping matched data only in the 2018 data
match_check <- match(arranged_diff$Country, data_2018$Country)
vector_match <- as.vector(match_check)
matched_2018 <- data_2018[c(vector_match), ]

#Combining the data 
private_health <- cbind(arranged_diff, matched_2018$`2018`)
colnames(private_health)[colnames(private_health) == "matched_2018$`2018`"] <- "Private Healthcare Expenditure Percentage"
View(private_health)

#Plotting a graph of percent reported/absolute difference against percentage healthcare expenditure
private_health2 <- private_health
colnames(private_health2)[colnames(private_health2) == "Percent Reported"] <- "Perc"
colnames(private_health2)[colnames(private_health2) == "Private Healthcare Expenditure Percentage"] <- "Private"

perc_graph <- ggplot(private_health2, aes(Private, Perc)) + 
        geom_point() + geom_smooth() + labs(title = "Percentage Private Healthcare vs Percentage Difference")

absolute_graph <- ggplot(private_health2, aes(Private, Difference)) + 
        geom_point() + geom_smooth() + labs(title = "Percentage Private Healthcare vs Absolute Difference")

#Removing data for difference < 100 cases 
private_100 <- private_health2[private_health2$Difference >= 100, ]
graph_100 <- ggplot(private_100, aes(Private, Difference)) + 
        geom_point() + geom_smooth() + labs(title = "Private vs Absolute excl. < 100 difference")

graph_100perc <- ggplot(private_100, aes(Private, Perc)) +
        geom_point() + geom_smooth() + labs(title = "Private vs Perc excl. < 100 difference")

#Removing data for percentage difference < 10% 
private_10 <- private_health2[private_health2$Perc >= 10, ]
graph_10 <- ggplot(private_10, aes(Private, Perc)) +
        geom_point() + geom_smooth() + labs(title = "Private vs Perc excl < 10% difference")

#Excluding serious outliers (including only 10-120% difference)
private_outlier <- private_10[private_10$Perc <= 120, ]
graph_outlier <- ggplot(private_outlier, aes(Private, Perc)) + 
        geom_point() + geom_smooth() + labs(title = "Private vs Perc incl 10-120% difference only")













