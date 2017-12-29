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
}
all_results <- do.call(rbind, all_results)
all_results$decade <- as.numeric(substr(all_results$season,1,1))
all_results$home_success <- ifelse(all_results$FTR == 'H',1 , 0)
all_results <- filter(all_results, season != '1718')
## Compare home away wins per season
result_comparison <- data.frame(table(all_results$season, all_results$FTR))
result_comparison <- reshape(result_comparison, idvar = "Var1", timevar = "Var2", direction = "wide")
result_comparison <- result_comparison[,c(1,3,4,5)]
names(result_comparison) <- c('season', 'AwayWins', 'Draw', 'HomeWins')
result_comparison$decade <- as.numeric(substr(result_comparison$season,1,1))
result_comparison$decade <- plyr::mapvalues(result_comparison$decade, from=c(0,1,9), to=c(2000, 2010, 1990))
result_comparison$season <- factor(result_comparison$season, ordered = TRUE, levels = seasons)


## Plot
ggplot(result_comparison, aes(x=season, y=HomeWins, group = 1)) + 
  geom_line(aes(color='steelblue2'), size=2, show.legend = TRUE) + 
  geom_smooth(method="lm") +
  geom_line(aes(y=AwayWins,  color='orange'), size=2, show.legend=TRUE) + 
  geom_smooth(aes(y=AwayWins),method="lm") + 
  geom_line(aes(y=Draw,  col='gray'), size=1, show.legend=TRUE) +
  geom_smooth(aes(y=Draw),method="lm") +
  xlab("Bundesliga Season") + 
  ylab("Number of Wins") + 
  ggtitle("Home vs. Away Wins in German Bundesliga 1993-2017") + 
  theme_minimal() +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=14,face="bold")) + 
  scale_color_manual("",values=c(steelblue2="steelblue2", orange="orange", gray="gray" ),
                      labels=c("Draw","AwayWin","HomeWin"))

# Percentage of HomeWins every season clearly above 0.33
result_comparison$perc_homewin <- result_comparison$HomeWins/306

## Compute avereage per decade seven seasons test 90s vs. 10s
avg_per_decade <- result_comparison %>%
                    group_by(decade) %>%
                    summarize(avg_homewin=mean(HomeWins),
                              avg_awaywin=mean(AwayWins),
                              avg_draws=mean(Draw),
                              no_matches=n()*306)

### Try Bayes AB Testing 
# try understanding it first :)
# Source: https://www.r-bloggers.com/bayesian-ab-testing-made-easy/
library(bayesAB)
nineties <- filter(all_results, decade==9)
tens <- filter(all_results, decade==1)
test1 <- bayesTest(tens$home_success, 
                   nineties$home_success, 
                   distribution = "bernoulli", 
                   priors = c("alpha" = 1071, "beta" = 1071))
print(test1)
summary(test1)
plot(test1)

### Frequentist AB Testing




## ADDITIONAL ADD 2ND BUNDESLIGA
