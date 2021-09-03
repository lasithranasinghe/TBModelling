#Loading the data set 
getwd()
setwd("/Users/Lasith/Desktop/AFP/Original Data/Variables Data")
data <- read_csv("Physicians_1000.csv", skip = 3)  #Ignoring the first 3 lines 

#removing unnecessary columns
clean1 <- select(data, !c("Country Code", "Indicator Name", "Indicator Code") )

#isolating 2019
doctor_2018 <- select(clean1, "Country Name", "2018")
sum(!is.na(doctor_2018$`2018`))

#omit na leaving us with 61 complete values 
nona_2018 <- na.omit(doctor_2018)
vect_doctor <- as.vector(nona_2018$`Country Name`)

#bringing in the percentage data 
difference_ <- select(percent_rep, "Country", "Difference", "Percent Reported")
matching <- match(nona_2018$`Country Name`, difference_$Country) #finding variables that match
nona_matching <- na.omit(matching) #removing na values (ones that didn't match)
vect_matching <- as.vector(nona_matching) 
subset_difference <- difference_[c(vect_matching), ] #creating difference table of only the necessary data
match2 <- match(subset$Country, nona_2018$`Country Name`)
subset_doctor <- nona_2018[ match2, ] #isolating only countries that are matching 

#Renaming columns to match
colnames(subset_doctor)[colnames(subset_doctor) == "2018"] <- "Physicians per 1000"
colnames(subset_doctor)[colnames(subset_doctor) == "Country Name"] <- "Country"

#New table with all data 
combined_diff_doct <- cbind(subset_difference, subset_doctor$`Physicians per 1000`)
alphabet_data <- arrange(combined_diff_doct, Country)
colnames(alphabet_data)
colnames(alphabet_data)[colnames(alphabet_data) ==
                                "subset_doctor$`Physicians per 1000`"] <- "Physicians per 1000"

ggplot(alphabet_data, aes(x = "Difference", y = "Physicians per 1000")) + geom_line()