# Home Advantage
suppressMessages(library(dplyr))
suppressWarnings(library(reshape2))
suppressMessages(library(ggplot2))


seasons <- c('9394','9495','9596','9697','9798','9899','9900','0001','0102','0203',
             '0304','0405','0506','0607','0708','0809','0910','1011','1112','1213',
             '1314','1415','1516','1617','1718')

# Download file with variable desriptions
# download.file("http://www.football-data.co.uk/notes.txt", destfile="data_map.txt")

all_results <- list() 

rm(tmp)
for(season in seasons){
  # download cheat for season
  file_url <- paste0("http://www.football-data.co.uk/mmz4281/",season,"/D1.csv")
  tmp_df <-  read.csv(url(file_url))
  # select only the first 7 coloumns with data, teams, goals, results 
  tmp_df <- tmp_df[,1:7] 
  # only matches with complete data
  tmp_df <- na.omit(tmp_df)
  tmp_df$season <- season
  all_results[[which(seasons == season)]] <- tmp_df
  rm(tmp_df)
}
all_results <- do.call(rbind, all_results)

## Compare home away wins per season
result_comparison <- data.frame(table(all_results$season, all_results$FTR))
result_comparison <- reshape(result_comparison, idvar = "Var1", timevar = "Var2", direction = "wide")
result_comparison <- result_comparison[,c(1,3,4,5)]
names(result_comparison) <- c('season', 'AwayWins', 'Draw', 'HomeWins')
result_comparison$decade <- as.numeric(substr(result_comparison$season,1,1))
result_comparison$decade <- plyr::mapvalues(result_comparison$decade, from=c(0,1,9), to=c(2000, 2010, 1990))
result_comparison$season <- factor(result_comparison$season, ordered = TRUE, levels = seasons)
result_comparison <- filter(result_comparison, season != '1718')

## Plot
ggplot(result_comparison, aes(x=season, y=HomeWins, group = 1)) + 
  geom_line(size=2, col='steelblue2') + 
  geom_line(aes(y=AwayWins), size=2, col='orange') + 
  geom_line(aes(y=Draw), size=1, col='gray') +
  xlab("Bundesliga Season") + 
  ylab("Number of Wins") + 
  ggtitle("Home vs. Away Wins in German Bundesliga 1993-2017") + 
  theme_bw()