# Home Advantage
setwd("/Users/matthiasgloel/heimvorteil/")

seasons <- c('9394','9495','9596','9697','9798','9899','9900','0001','0102','0203',
             '0304','0405','0506','0607','0708','0809','0910','1011','1112','1213',
             '1314','1415','1516','1617','1718')


download.file("http://www.football-data.co.uk/notes.txt", destfile="data_map.txt")

all_results <- data.frame() 
X <- read.csv(url("http://www.football-data.co.uk/mmz4281/1718/D1.csv"))
