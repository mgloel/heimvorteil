# Home Advantage
library(ggplot2)
setwd("/Users/matthiasgloel/heimvorteil/")

seasons <- c('9394','9495','9596','9697','9798','9899','9900','0001','0102','0203',
             '0304','0405','0506','0607','0708','0809','0910','1011','1112','1213',
             '1314','1415','1516','1617','1718')

# Download file with variable desriptions
download.file("http://www.football-data.co.uk/notes.txt", destfile="data_map.txt")

all_results <- list() 

rm(tmp)
for(season in seasons){
  # download cheat for season
  file_url <- paste0("http://www.football-data.co.uk/mmz4281/",season,"/D1.csv")
  tmp_df <-  read.csv(url(file_url))
  # select only the first 7 coloumns with data, teams, goals, results 
  tmp_df <- tmp_df[,1:7] 
  all_results[[which(seasons == season)]] <- tmp_df
  rm(tmp_df)
}
all_results <- do.call(rbind, all_results)