#Load the data for Xpert Cartridges 
setwd("~/Desktop/AFP/Original Data/Variables Data")
data <- read_csv("Xpert_Catridge.csv", skip = 2)

#Isolating the relevant data 
data_1 <- data[1:24, 1:37]

#Removing additional rows for GeneXpert subtype and renaming the columns
data_2 <- data_1[-(1:2), ]
colnames(data_2)[colnames(data_2) == "Type of Xpert machines"] <- "GeneXpert_1"
colnames(data_2)[colnames(data_2) == "...17"] <- "GeneXpert_2"
colnames(data_2)[colnames(data_2) == "...18"] <- "GeneXpert_4"
colnames(data_2)[colnames(data_2) == "...19"] <- "GeneXpert_16"
colnames(data_2)[colnames(data_2) == "...1"] <- "Country"

#Removing further columns 
data_3 <- data_2[ , c(1, 2, 3, 4, 8, 14, 15)]

#Separating each column out to allow for comparison to the difference data 
cartridges <- data_3[ , c(1,2)]
modules <- data_3[ , c(1, 3)]
labs_only <- data_3[ , c(1, 4)]
labs_open <- data_3[ , c(1, 5)]

#Cartridges data compared to difference data 
diff_data <- percent_rep[ , c(1,4,5)]
cartridge_nona <- na.omit(cartridges)
match_diff <- match(cartridge_nona$Country, diff_data$Country)
cartridge_diff <- diff_data[na.omit(c(match_diff)), ]

#Removing DR Congo from the cartridge_nona data 
cartridge_nona <- cartridge_nona[-6, ]
identical(cartridge_nona$Country, cartridge_diff$Country)

cart_diff_final <- cbind(cartridge_diff, cartridge_nona$`Cartridges Procured...2`)

colnames(cart_diff_final)[colnames(cart_diff_final) == "Percent Reported"] <- "Percent_Reported"

colnames(cart_diff_final)[colnames(cart_diff_final) == "cartridge_nona$`Cartridges Procured...2`"] <- "Cartridges"
colnames(cart_diff_final)

##Plot for cartridges against percentage reported 
J <- ggplot(data = cart_diff_final, aes(x = Cartridges, y = Percent_Reported)) + geom_point()

#Plot for cartridges against percentage reported 
K <- ggplot(data = cart_diff_final, aes(x = Cartridges, y = Difference)) + geom_point() + geom_smooth()


