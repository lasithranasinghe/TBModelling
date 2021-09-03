View(TBnotif)
TBnot <- as.data.frame(TBnotif)
firstfilter <- select(TBnot, "country", "year", "newrel_m04",
                      "newrel_m014", "newrel_m1014", "newrel_m514", "newrel_f04",
                      "newrel_f014", "newrel_f1014", "newrel_f514")
secondfilter <- filter(firstfilter, year == 2019)
TBnotifclean <- secondfilter
TBnotiffinal <- TBnotifclean %>% drop_na() %>% mutate("total_014"=newrel_m014 + newrel_f014,
                                        "total_04" = newrel_m04 + newrel_f04,
                                        "total_514" = newrel_f514 + newrel_m514,
                                        "total_1014" = newrel_m1014 + newrel_f1014)
