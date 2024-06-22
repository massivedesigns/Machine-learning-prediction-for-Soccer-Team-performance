library(worldfootballR)
library(dplyr)

# install.packages("devtools")
devtools::install_github("JaseZiv/worldfootballR")
library(worldfootballR)

# fb_league_urls() extracts any country's league on fbref url
# To get the url for the men's championship season 2020/2021

ut <- fb_league_urls(country = "ENG", 
               gender = "M", 
               season_end_year = 2023, 
               tier = '1st')

View(ut)


# fb_match_results - Pull data of all results in the EPL in season 2022/2023

Season_22_23 <- fb_match_results(country = "ENG",
                                 gender = "M",
                                 season_end_year = "2023",
                                 tier = "1st",
                                 non_dom_league_url = NA)

View(Season_22_23)


# Save data as a CSV to your route folder
# To save to folder you can replace "Season_22_23.csv" with something like C:\\Users\\add user name here\\folder to save to\\Season_22_23.csv"

write.csv(Season_22_23, 
          "/Users/mac/Downloads/R-footballscripts/Season_22_23.csv", 
          row.names = FALSE)

# matchdata for 2022/2023
Season_22_23_Match_Data <- fb_match_summary(Season_22_23$MatchURL, 
                                            time_pause = 3)

View(Season_22_23_Match_Data)

write.csv(Season_22_23_Match_Data, 
          "/Users/mac/Downloads/R-footballscripts/Season_22_23_Match_Data.csv", 
          row.names = FALSE)
-----------------------------------------------------------------------------------------------------------------------------
# more experiments to collect player info match by match 
  
# (Season_22_23_Match_Data$Game_URL, time_pause = 3)  

match_lineup <- fb_match_lineups("https://fbref.com/en/matches/e62f6e78/Crystal-Palace-Arsenal-August-5-2022-Premier-League")

View(match_lineup)

rp <- fb_match_report("https://fbref.com/en/matches/e62f6e78/Crystal-Palace-Arsenal-August-5-2022-Premier-League", time_pause = 3)
View(rp)

mtchshot<- fb_match_shooting("https://fbref.com/en/matches/e62f6e78/Crystal-Palace-Arsenal-August-5-2022-Premier-League", time_pause = 3)
View(mtchshot)

# match log for every player 
game1 <- fb_player_match_logs(match_lineup$PlayerURL, season_end_year = "2023", stat_type = "summary", time_pause = 3)
View(game1)

# Initialize an empty list to store match logs for each player
match_logs_list <- list()

# Loop through each player URL
for (url in match_lineup$PlayerURL) {
  # Fetch match logs for the player
  match_logs <- fb_player_match_logs(url, season_end_year = "2023", stat_type = "summary", time_pause = 3)
  
  # Append the match logs to the list
  match_logs_list[[url]] <- match_logs
}

# Now match_logs_list contains match logs for each player

View(match_logs_list[url])

View(match_logs_list[[url]])

# Iterate over each element in match_logs_list and view the dataframe
for (i in seq_along(match_logs_list)) {
  View(match_logs_list[[i]])
}



# Loop through each dataframe in the list
for (i in seq_along(match_logs_list)) {
  # Get the shape of the dataframe
  shape <- dim(match_logs_list[[i]])
  
  # Print the shape
  cat("Dataframe", i, "has", shape[1], "rows and", shape[2], "columns.\n")
}

library(dplyr)

# Combine all dataframes into one large dataframe row-wise
combined_match_logs <- bind_rows(match_logs_list)

# View the combined dataframe
View(combined_match_logs)

### trying again for my main result 
# 
# (Season_22_23$MatchURL, time_pause = 3) 

match_lineup2 <- fb_match_lineups(Season_22_23$MatchURL) # here i want a loop that picks each url in Season_22_23$MatchURL and places it in here because this only takes url and not columns url put in  " "

# write.csv(match_lineup2, 
#           "/Users/mac/Downloads/R-footballscripts/match_lineup2.csv", 
#           row.names = FALSE)


# Initialize an empty list to store match logs for each player
match_logs_list2 <- list()

# Loop through each player URL
for (url in match_lineup2$PlayerURL) {
  # Fetch match logs for the player
  match_logs <- fb_player_match_logs(url, season_end_year = "2023", stat_type = "summary", time_pause = 3)
  
  # Append the match logs to the list
  match_logs_list2[[url]] <- match_logs
}

# Combine all dataframes into one large dataframe row-wise
combined_match_logs2 <- bind_rows(match_logs_list2)

# View the combined dataframe
View(combined_match_logs2)


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

# Initialize an empty list to store match logs for each player
match_logs_list2 <- list()

# Loop through each match URL
for (url in Season_22_23$MatchURL) {
  # Fetch match lineups for the current match URL
  match_lineup2 <- fb_match_lineups(url)
  
  # Loop through each player URL in the match lineup
  for (player_url in match_lineup2$PlayerURL) {
    # Fetch match logs for the player
    match_logs <- fb_player_match_logs(player_url, season_end_year = "2023", stat_type = "summary", time_pause = 3)
    
    # Append the match logs to the list
    match_logs_list2[[player_url]] <- match_logs
  }
}

# Combine all dataframes into one large dataframe row-wise
combined_match_logs2 <- bind_rows(match_logs_list2)

# View the combined dataframe
View(combined_match_logs2)

  
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


----
# Initialize an empty dataframe to store all match logs
all_match_logs <- data.frame()

# Loop through each player URL
for (url in match_lineup$PlayerURL) {
  # Fetch match logs for the player
  match_logs <- fb_player_match_logs(url, season_end_year = "2023", stat_type = "summary", time_pause = 3)
  
  # Append the match logs to the dataframe
  all_match_logs <- rbind(all_match_logs, match_logs)
}

# Now all_match_logs contains all match logs for all players
View(all_match_logs)


---------------------------------------------------------------------------------------
pstandard <- fb_league_stats(country = "ENG",
                            gender = "M",
                            season_end_year = "2023",
                            tier = "1st",
                            non_dom_league_url = NA,
                            stat_type = "standard",
                            team_or_player = "team",
                            time_pause = 3,
                            rate = purrr::rate_backoff(max_times = 3) 
                            )
View(pstandard)

stat_type <- c("standard", "shooting", "passing", "passing_types", "gca", 
               "defense", "possession", "playing_time", "misc", 
               "keepers", "keepers_adv")


fb_league_stats(country = "ENG",
                gender = "M",
                season_end_year = "2023",
                tier = "1st",
                non_dom_league_url = NA,
                stat_type = "shooting",
                team_or_player = "player",
                time_pause = 3,
                rate = purrr::rate_backoff(max_times = 3) 
)
----
  ----
  ---
library(purrr)  # For rate_backoff function
library(readr)  # For write_csv function

# List of stat types
# i have gotten  "shooting",
stat_type <- c("standard",  "passing", "passing_types", "gca", 
               "defense", "possession", "playing_time", "misc", 
               "keepers", "keepers_adv")

# Loop through each stat type
for (type in stat_type) {
  # Call fb_league_stats with current stat type
  df <- fb_league_stats(country = "ENG",
                        gender = "M",
                        season_end_year = "2023",
                        tier = "1st",
                        non_dom_league_url = NA,
                        stat_type = type,
                        team_or_player = "player",
                        time_pause = 3,
                        rate = rate_backoff(max_times = 3))
  
  # Save dataframe with stat type name
  filename <- paste0(type, "_2023_player_stats.csv")
  write_csv(df, filename)
}
----
  ------
  --------
----------------------------------------------------------------------------------------------
#Error in fb_league_stats(country = "ENG", gender = "M", season_end_year = "2023",  : 
                           #could not find function "fb_league_stats"


prem_2023_st <- fb_season_team_stats(country = "ENG", 
                                     gender = "M", 
                                     season_end_year = "2023", 
                                     tier = "1st", 
                                     stat_type = "standard")

View(prem_2023_st)

# ----------------------------------------------------------------------------------------
library(tidyverse)  # Assuming you're using tidyverse functions

# Define the list of elements
elements <- c("standard","possession","shooting", "passing", "passing_types","defense", "misc","goal_shot_creation",
              "playing_time", "league_table", "league_table_home_away",  "keeper", "keeper_adv")

# Initialize an empty list to store dataframes
result_list <- list()

# Loop through each element and call the function with appropriate parameters
for (element in elements) {
  result <- fb_season_team_stats(country = "ENG", 
                                 gender = "M", 
                                 season_end_year = "2023", 
                                 tier = "1st", 
                                 stat_type = element)
  
  # Assuming the result is returned as a dataframe
  result_list[[element]] <- result
}



# Combine dataframes from result_list column-wise
joined_team_stat <- do.call(cbind, result_list)

# Print the structure of the joined dataframe
str(joined_team_stat)

View(joined_team_stat)

# write.csv(joined_team_stat, 
#           "/Users/mac/Downloads/R-footballscripts/joined_team_stat.csv", 
#           row.names = FALSE)
# Now result_list contains all the dataframes

View(result_list[["defense"]])
----------------------------------------------------------------------------------------------------------------------

fb_player_season_stats(player_url, stat_type, national = FALSE, time_pause = 3)



-----------------------------------------------------------------
usethis::edit_r_environ()
Sys.getenv("GITHUB_PAT")
-------------------------------------------------------------------
  
# lets start for all players then
h23 <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2023, tier = '1st')

teams_urls <- fb_teams_urls(h23)

# Initialize a list to store player URLs for each team
# team_player_urls <- list()

# Loop through each team URL
for (team_url in teams_urls) {
  # Get player URLs for the current team
  player_urls <- fb_player_urls(team_url)
  
  # Store player URLs for the current team
  team_player_urls[[team_url]] <- player_urls
}

View(team_player_urls)
-------------------------------------------------------------
  
# Get league URLs
h234 <- fb_league_urls(country = "ENG", gender = "M", season_end_year = 2023, tier = '1st')
View(h234)

# Get teams URLs
teams_urls <- fb_teams_urls(h234)

# Create an empty list to store dataframes for each team
team_player_dataframes <- list()

# Loop through each team URL
for (team_url in teams_urls) {
  # Get player URLs for the current team
  player_urls <- fb_player_urls(team_url)
  
  # Create a dataframe for the current team's player URLs
  team_player_df <- data.frame(player_url = player_urls)
  # Create a dataframe for the current team's player URLs
  team_player_df <- data.frame(player_url = player_urls)
  
  # Extract team name from the URL
  team_name <- sub("^.*/", "", team_url)  # Extracts last part of the URL as team name
  
  # Assign the dataframe to the list with the team name as key
  team_player_dataframes[[team_name]] <- team_player_df
}

View(team_player_dataframes)


View(team_player_dataframes[['Manchester-United-Stats']])


-- shooting ---------

prem_2020_player_shooting <- fb_league_stats(
  country = "ENG",
  gender = "M",
  season_end_year = 2023,
  tier = "1st",
  non_dom_league_url = NA,
  stat_type = "shooting",
  team_or_player = "player"
)
dplyr::glimpse(prem_2020_player_shooting)

View(prem_2020_player_shooting)


multiple_playing_time <- fb_player_season_stats(player_url = player_urls,
                                                stat_type = "standard")

View(multiple_playing_time)
 

pp <- filter(
  multiple_playing_time, 
  Season == "2022-2023" & Comp == "1. Premier League"
)
View(pp)
colnames(multiple_playing_time)


# Display column names
colnames(multiple_playing_time)

# Check the case sensitivity of column names
tolower(colnames(multiple_playing_time))

# Check the existence of the 'Season' and 'comp' columns
"Season" %in% colnames(multiple_playing_time)
"Comp" %in% colnames(multiple_playing_time)









