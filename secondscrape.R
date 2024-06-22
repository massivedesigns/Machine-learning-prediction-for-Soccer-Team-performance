library(worldfootballR)
library(dplyr)

# fb_match_results - Pull data of all results in the EPL in season 2022/2023

Season_22_23b <- fb_match_results(country = "ENG",
                                 gender = "M",
                                 season_end_year = "2023",
                                 tier = "1st",
                                 non_dom_league_url = NA)

View(Season_22_23b)

#matchdata for 2022/2023
Season_22_23_Match_Datab <- fb_match_summary(Season_22_23b$MatchURL, 
                                             time_pause = 3)

View(Season_22_23_Match_Datab)


unique_game_urls_df <- data.frame(GameURL = unique(Season_22_23_Match_Datab$GameURL))

#-------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------
  
# Initialize an empty list to store match logs for each player
 match_logs_list2 <- list()
  
# Loop through each match URL
  for (url in unique_game_urls_df) {
    # Fetch match lineups for the current match URL
    match_lineup2 <- fb_match_lineups(url)
  }

# Loop through each player URL in the match lineup
  for (player_url in match_lineup2$PlayerURL) {
  # Fetch match logs for the player
  match_logs <- fb_player_match_logs(player_url, season_end_year = "2023", stat_type = "summary", time_pause = 3)
  
  # Append the match logs to the list
  match_logs_list2[[player_url]] <- match_logs
  }

  # Combine all dataframes into one large dataframe row-wise
  combined_match_logs2 <- bind_rows(match_logs_list2)
  
  # View the combined dataframe
  View(combined_match_logs2)
  
  
  # Initialize empty lists to store dataframes with 30 columns, 38 columns, and others
  match_logs_list_30 <- list()
  match_logs_list_38 <- list()
  match_logs_list_others <- list()
  
  # Iterate through each dataframe in match_logs_list2
  for (i in seq_along(match_logs_list2)) {
    # Check the number of columns in the current dataframe
    num_cols <- ncol(match_logs_list2[[i]])
    
    # Add the dataframe to the appropriate list based on the number of columns
    if (num_cols == 30) {
      match_logs_list_30 <- c(match_logs_list_30, list(match_logs_list2[[i]]))
    } else if (num_cols == 38) {
      match_logs_list_38 <- c(match_logs_list_38, list(match_logs_list2[[i]]))
    } else {
      match_logs_list_others <- c(match_logs_list_others, list(match_logs_list2[[i]]))
    }
  }
  
  # Combine dataframes with 30 columns into one large dataframe row-wise
  combined_match_logs_30 <- do.call(rbind, match_logs_list_30)
  
  # Combine dataframes with 38 columns into one large dataframe row-wise
  combined_match_logs_38 <- do.call(rbind, match_logs_list_38)
  
  # Combine dataframes with 46 columns into one large dataframe row-wise
  combined_match_logs_46 <- do.call(rbind, match_logs_list_others)
  
  # View the combined dataframes
  View(combined_match_logs_30)
  View(combined_match_logs_38)
  View(combined_match_logs_46)
  
  
  
  # Filter the combined dataframe
  Epl_playerlogs30 <- filter(combined_match_logs_30, Comp == "Premier League")
  Epl_playerlogs30 <- filter(combined_match_logs_38, Comp == "Premier League")
  Epl_playerlogs30 <- filter(combined_match_logs_46, Comp == "Premier League")
  Epl_playerlogs <- filter(combined_match_logs2, Comp == "Premier League")
  
  View(Epl_playerlogs30)
  
  # # Define the file path for the new folder
  # folder_path <- "/Users/mac/Downloads/R-footballscripts/filtered_summary"
  # 
  # # Create the folder if it doesn't exist
  # if (!file.exists(folder_path)) {
  #   dir.create(folder_path)
  # }
  # 
  # # Define the file paths for each filtered dataframe
  # file_path_30 <- file.path(folder_path, "Epl_playerlogs30.csv")
  # file_path_38 <- file.path(folder_path, "Epl_playerlogs38.csv")
  # file_path_46 <- file.path(folder_path, "Epl_playerlogs46.csv")
  # file_path_all <- file.path(folder_path, "Epl_playerlogs.csv")
  # 
  # # Save each filtered dataframe as a CSV file
  # write.csv(Epl_playerlogs30, file_path_30, row.names = FALSE)
  # write.csv(Epl_playerlogs38, file_path_38, row.names = FALSE)
  # write.csv(Epl_playerlogs46, file_path_46, row.names = FALSE)
  # write.csv(Epl_playerlogs, file_path_all, row.names = FALSE)
  
  
  unique(Epl_playerlogs$Player)
#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
  ######################################################################################################
    # Initialize the list of stat types
  stat_type <- list("misc", "defense", "passing", "passing_types", "gca", "keepers", "possession")
  
  # Initialize an empty list to store logs for each stat type
  logs_by_stat_type <- list()
  
  # Loop through each stat type
  for (type in stat_type) {
    cat("Fetching logs for stat type:", type, "\n")  # Print the current stat type
    # Fetch logs for all players in the current stat type
    logs <- lapply(match_lineup2$PlayerURL, function(player_url) {
      fb_player_match_logs(player_url, season_end_year = "2023", stat_type = type, time_pause = 3)
    }) |> bind_rows()  # Combine logs for all players into one dataframe
    
    # Name the combined dataframe according to the stat type
    logs_by_stat_type[[paste0(type, "_logs")]] <- logs
  }
  
  # View the list of dataframes
  View(logs_by_stat_type)
  
  
  

  ######################################################################################################
  
  
  
  # # Loop through each match URL
  # for (url in unique_game_urls_df) {
  #   # Fetch match lineups for the current match URL
  #   match_lineup2 <- fb_match_lineups(url)
  # }
  
 
  # write.csv(match_lineup2, 
  #           "/Users/mac/Downloads/R-footballscripts/match_lineup2.csv", 
  #           row.names = FALSE)
  

  
  # Read the CSV file into R
  match_lineup2 <- read.csv("/Users/mac/R-footballscripts/rawdata/match_lineup2.csv")
  
  # Display the first few rows of the data
  head(match_lineup2)
  
  unique(match_lineup2$PlayerURL)
  length(unique(match_lineup2$PlayerURL))
  
  
  
  # Initialize an empty list to store match logs for each player passing stat
  match_logs_passing <- list()
  
  # Loop through each player URL in the match lineup
  for (player_url in unique(match_lineup2$PlayerURL)) {
    
    # Fetch match logs for the player
    ppassing_logs <- fb_player_match_logs(player_url, season_end_year = '2023', stat_type = 'passing', time_pause = 3)
    
    # Append the match logs to the list
    match_logs_passing[[player_url]] <- ppassing_logs
  }
  
  # Combine all dataframes into one large dataframe row-wise
  combined_match_logs_passing <- bind_rows(match_logs_passing)
  
  # View the combined dataframe
  View( combined_match_logs_passing)
  
  length(unique(combined_match_logs_passing$Player))
  
  length(unique(Epl_playerlogs$Player))
  
  # try({
  #   fb_player_match_logs("https://fbref.com/en/players/3bb7b8b4/Ederson",
  #                        season_end_year = 2023, stat_type = 'passing')
  # })