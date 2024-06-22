library(worldfootballR)
library(dplyr)

test
# Read the CSV file into R
match_lineup2 <- read.csv("/Users/mac/R-footballscripts/rawdata/match_lineup2.csv")

# Display the first few rows of the data
head(match_lineup2)

View(unique(match_lineup2$PlayerURL))
length(unique(match_lineup2$PlayerURL))

urls <- list(unique(match_lineup2$PlayerURL))
View(urls)
a1 <- try({
  fb_player_match_logs("https://fbref.com/en/players/ab13a5aa/Vicente-Guaita",
                       season_end_year = 2023, stat_type = 'passing')
})

#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
1

# Empty dataframe to store the results
combined_df <- data.frame()


# Loop through each URL
for (url in urls) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'passing')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      combined_df <- bind_rows(combined_df, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(combined_df)
View(unique(combined_df$Player))
length(unique(combined_df$Player))

# write.csv(combined_df, file = "/Users/mac/R-footballscripts/players_matchlog/player_passing_logs.csv", row.names = FALSE)

#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################

2
# Empty dataframe to store the results
combined_df2 <- data.frame()

# URLs to be processed
urls2 <- list(
  "https://fbref.com/en/players/5e253986/Brandon-Austin",
  "https://fbref.com/en/players/cee31595/James-McArthur",
  "https://fbref.com/en/players/f173303a/Yasin-Ayari",
  "https://fbref.com/en/players/8b57ad2c/Joao-Gomes",
  "https://fbref.com/en/players/c6e8cf1f/Sasa-Lukic",
  "https://fbref.com/en/players/2c6835e5/Lewis-Miley",
  "https://fbref.com/en/players/17850779/Diogo-Monteiro",
  "https://fbref.com/en/players/3b57a494/Jeremiah-Chilokoa-Mullen",
  "https://fbref.com/en/players/be18d79f/Oliwier-Zych",
  "https://fbref.com/en/players/a42f6058/Sil-Swinkels",
  "https://fbref.com/en/players/c47541e0/Bertrand-Traore",
  "https://fbref.com/en/players/cd4b2c5f/Kaelan-Casey",
  "https://fbref.com/en/players/012c975a/Rhys-Williams",
  "https://fbref.com/en/players/4eb2d015/Thomas-Mcgill",
  "https://fbref.com/en/players/0bdeb013/Cameron-Peupion",
  "https://fbref.com/en/players/8218e831/Imari-Samuels",
  "https://fbref.com/en/players/eafaafa5/George-Wickens",
  "https://fbref.com/en/players/dc4cae05/David-Brooks",
  "https://fbref.com/en/players/48b3dd60/Arthur-Melo",
  "https://fbref.com/en/players/597610cd/Romaine-Mundle",
  "https://fbref.com/en/players/5ab61aea/George-Shelvey",
  "https://fbref.com/en/players/693a5e1a/Charlie-Robinson",
  "https://fbref.com/en/players/501ac0cc/Reuell-Walters",
  "https://fbref.com/en/players/cdd70dc0/Michael-Olakigbe",
  "https://fbref.com/en/players/88968486/Illia-Zabarnyi",
  "https://fbref.com/en/players/9417a430/James-Wright",
  "https://fbref.com/en/players/ba08056d/Alfie-Devine",
  "https://fbref.com/en/players/d524dcd7/Terry-Ablade",
  "https://fbref.com/en/players/10b9fa99/Ethan-Ampadu",
  "https://fbref.com/en/players/77cf6852/Emil-Krafth",
  "https://fbref.com/en/players/fd08a24b/Harvey-Davies",
  "https://fbref.com/en/players/8525ec2a/Seb-Revan",
  "https://fbref.com/en/players/e0b5d31b/Travis-Patterson",
  "https://fbref.com/en/players/56628958/George-Abbott",
  "https://fbref.com/en/players/da95fde0/Ishe-Samuels-Smith",
  "https://fbref.com/en/players/c1d75f69/Marc-Jurado",
  "https://fbref.com/en/players/165cf989/Andy-Lonergan",
  "https://fbref.com/en/players/5cc3ce65/Shea-Charles",
  "https://fbref.com/en/players/91ca4a16/Nico-OReilly",
  "https://fbref.com/en/players/3434ac72/Alexander-Robertson",
  "https://fbref.com/en/players/190163f3/Ben-Knight"
)
# Loop through each URL
for (url in urls2) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'passing')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      combined_df2 <- bind_rows(combined_df2, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}
# View the combined dataframe
View(combined_df2)
View(unique(combined_df2$Player))
length(unique(combined_df2$Player))

# write.csv(combined_df2, file = "/Users/mac/R-footballscripts/players_matchlog/player_passing_logs2.csv", row.names = FALSE)

#---------------------------------------------------------------------------------------------------------
# Initialize the list of stat types
#stat_type <- list("summary", "passing", "defense", "possession", "misc",   "passing_types", "gca", "keepers", )
#---------------------------------------------------------------------------------------------------------
######################################################################################################

3 -- defense logs
# URLs to exclude
exclude <- list(
  "https://fbref.com/en/players/2140e999/Luke-Plange",
  "https://fbref.com/en/players/f76e6b4e/Adrian",
  "https://fbref.com/en/players/7d6af698/Luke-Chambers",
  "https://fbref.com/en/players/3fe6bd8c/Paul-Dummett",
  "https://fbref.com/en/players/3e80e04e/Lyle-Taylor",
  "https://fbref.com/en/players/3766178e/Oliver-Hammond",
  "https://fbref.com/en/players/3f70db80/Kristoffer-Klaesson",
  "https://fbref.com/en/players/f58515f5/Archie-Gray",
  "https://fbref.com/en/players/d8edc4be/Will-Dennis",
  "https://fbref.com/en/players/69942fb3/James-Hill",
  "https://fbref.com/en/players/cc700722/Allan",
  "https://fbref.com/en/players/8e633970/Lewis-Warrington",
  "https://fbref.com/en/players/c0a454d5/Stanley-Mills",
  "https://fbref.com/en/players/339fe0e8/Thomas-Strakosha",
  "https://fbref.com/en/players/a6de6361/Tom-Heaton",
  "https://fbref.com/en/players/6385ebfb/Darren-Randolph",
  "https://fbref.com/en/players/9f684e25/Sammy-Braybrooke",
  "https://fbref.com/en/players/32e7ce92/Loris-Karius",
  "https://fbref.com/en/players/fea06849/Matthew-Cox",
  "https://fbref.com/en/players/9bbef03e/Ed-Turns",
  "https://fbref.com/en/players/e0eea46f/Martial-Godo",
  "https://fbref.com/en/players/d7e24aa1/John-Kymani-Gordon",
  "https://fbref.com/en/players/c9093a1a/Kyle-Alex-John",
  "https://fbref.com/en/players/bca5c4a7/Lamare-Bogarde",
  "https://fbref.com/en/players/0284bd0d/Kofi-Balmer",
  "https://fbref.com/en/players/a182122b/Reece-Welch",
  "https://fbref.com/en/players/6fa3c28e/Zidane-Iqbal",
  "https://fbref.com/en/players/8074e66f/Owen-Goodman",
  "https://fbref.com/en/players/1900032e/Jannik-Vestergaard",
  "https://fbref.com/en/players/59d2e6bb/Joe-Wormleighton",
  "https://fbref.com/en/players/04eb7d82/Amario-Duberry",
  "https://fbref.com/en/players/cfa9f361/Killian-Phillips",
  "https://fbref.com/en/players/130e085a/Tristan-Crama",
  "https://fbref.com/en/players/9610c9c1/Ryan-Finnigan",
  "https://fbref.com/en/players/32e9d210/Lewis-Payne",
  "https://fbref.com/en/players/3e1550ee/Scott-Carson",
  "https://fbref.com/en/players/907a5d7c/Yehor-Yarmoliuk",
  "https://fbref.com/en/players/a71ebcc8/Jack-Wells-Morrison",
  "https://fbref.com/en/players/ab18d1b0/James-Furlong",
  "https://fbref.com/en/players/8c45f10e/Cameron-Plain",
  "https://fbref.com/en/players/aa81d8f8/Karl-Jakob-Hein",
  "https://fbref.com/en/players/bf713136/Nathan-Bishop",
  "https://fbref.com/en/players/732327ae/Ryan-Trevitt",
  "https://fbref.com/en/players/00b77ecf/Nathan-Fraser",
  "https://fbref.com/en/players/6e4cb264/Harvey-Griffiths",
  "https://fbref.com/en/players/0d85a4e8/Marcus-Bettinelli",
  "https://fbref.com/en/players/00f0482f/Shola-Shoretire",
  "https://fbref.com/en/players/87f12e30/Sonny-Perkins",
  "https://fbref.com/en/players/d5094280/Dale-Taylor",
  "https://fbref.com/en/players/e20a28ce/Kristian-Sekularac",
  "https://fbref.com/en/players/a179d516/Willy-Caballero",
  "https://fbref.com/en/players/f9d409a1/Jimmy-Morgan",
  "https://fbref.com/en/players/cc70a1d5/Jack-Butland",
  "https://fbref.com/en/players/a79abd8b/Filip-Marshall",
  "https://fbref.com/en/players/91c75917/Kadan-Young",
  "https://fbref.com/en/players/5e74d6c8/Brandon-Williams",
  "https://fbref.com/en/players/e4588897/Rhys-Bennett",
  "https://fbref.com/en/players/cfca9c4e/Jordan-Smith",
  "https://fbref.com/en/players/b2c66859/Kasey-McAteer",
  "https://fbref.com/en/players/3a686640/Nathan-Butler-Oyedeji",
  "https://fbref.com/en/players/54778940/Dominic-Sadi",
  "https://fbref.com/en/players/c1426015/Michael-DaCosta",
  "https://fbref.com/en/players/2093823e/Daniel-Adu-Adjei",
  "https://fbref.com/en/players/54b6eed9/Matthew-Smith",
  "https://fbref.com/en/players/ea0271ee/Euan-Pollock",
  "https://fbref.com/en/players/a48635b8/Viljami-Sinisalo",
  "https://fbref.com/en/players/6faae64f/Wanya-Marcal-Madivadua",
  "https://fbref.com/en/players/7eda24fe/Ben-Greenwood",
  "https://fbref.com/en/players/ed46ab76/Maxwell-Wellings",
  "https://fbref.com/en/players/2411c7f7/Krisztian-Hegyi",
  "https://fbref.com/en/players/21a866b7/Joseph-Anang",
  "https://fbref.com/en/players/5e253986/Brandon-Austin",
  "https://fbref.com/en/players/d91f104d/Alfie-Gilchrist",
  "https://fbref.com/en/players/345fc437/Tommi-OReilly",
  "https://fbref.com/en/players/979cb300/Matt-Dibley-Dias",
  "https://fbref.com/en/players/bb91617c/Alex-Smithies",
  "https://fbref.com/en/players/c150b220/Tayo-Adaramola",
  "https://fbref.com/en/players/66c0246b/Sean-McAllister",
  "https://fbref.com/en/players/9b67eca8/Mauro-Bandeira",
  "https://fbref.com/en/players/fe80cc4a/Ethan-Wady",
  "https://fbref.com/en/players/e32958b7/Mark-Gillespie",
  "https://fbref.com/en/players/88b3215c/Yago-Santiago",
  "https://fbref.com/en/players/49375cdd/Kaden-Rodney",
  "https://fbref.com/en/players/af102dc3/Christian-Saydee",
  "https://fbref.com/en/players/bc67a0e1/Matej-Kovar",
  "https://fbref.com/en/players/e09d77a2/Lino-Sousa",
  "https://fbref.com/en/players/66b290f7/Stefan-Parkes",
  "https://fbref.com/en/players/17850779/Diogo-Monteiro",
  "https://fbref.com/en/players/3b57a494/Jeremiah-Chilokoa-Mullen",
  "https://fbref.com/en/players/be18d79f/Oliwier-Zych",
  "https://fbref.com/en/players/a42f6058/Sil-Swinkels",
  "https://fbref.com/en/players/4eb2d015/Thomas-Mcgill",
  "https://fbref.com/en/players/8218e831/Imari-Samuels",
  "https://fbref.com/en/players/eafaafa5/George-Wickens",
  "https://fbref.com/en/players/597610cd/Romaine-Mundle",
  "https://fbref.com/en/players/5ab61aea/George-Shelvey",
  "https://fbref.com/en/players/693a5e1a/Charlie-Robinson",
  "https://fbref.com/en/players/501ac0cc/Reuell-Walters",
  "https://fbref.com/en/players/cdd70dc0/Michael-Olakigbe",
  "https://fbref.com/en/players/9417a430/James-Wright",
  "https://fbref.com/en/players/ba08056d/Alfie-Devine",
  "https://fbref.com/en/players/d524dcd7/Terry-Ablade",
  "https://fbref.com/en/players/fd08a24b/Harvey-Davies",
  "https://fbref.com/en/players/8525ec2a/Seb-Revan",
  "https://fbref.com/en/players/e0b5d31b/Travis-Patterson",
  "https://fbref.com/en/players/da95fde0/Ishe-Samuels-Smith",
  "https://fbref.com/en/players/c1d75f69/Marc-Jurado",
  "https://fbref.com/en/players/165cf989/Andy-Lonergan",
  "https://fbref.com/en/players/91ca4a16/Nico-OReilly",
  "https://fbref.com/en/players/3434ac72/Alexander-Robertson",
  "https://fbref.com/en/players/190163f3/Ben-Knight"
)

# Empty dataframe to store the results
player_defense_log <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'defense')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_defense_log <- bind_rows(player_defense_log, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_defense_log)
View(unique(player_defense_log$Player))
length(unique(player_defense_log$Player))
write.csv(player_defense_log, file = "/Users/mac/R-footballscripts/players_matchlog/player_defense_log.csv", row.names = FALSE)


#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
4 -- possession logs

# Empty dataframe to store the results
player_possession_log <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'possession')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_possession_log <- bind_rows(player_possession_log, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_possession_log)
View(unique(player_possession_log$Player))
length(unique(player_possession_log$Player))
write.csv(player_possession_log, file = "/Users/mac/R-footballscripts/players_matchlog/player_possession_log.csv", row.names = FALSE)

#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
5 -- misc logs

# Empty dataframe to store the results
player_misc_log <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'misc')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_misc_log <- bind_rows(player_misc_log, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_misc_log)
View(unique(player_misc_log$Player))
length(unique(player_misc_log$Player))
 write.csv(player_misc_log, file = "/Users/mac/R-footballscripts/players_matchlog/player_misc_log.csv", row.names = FALSE)


#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
6 -- passing_types logs

# Empty dataframe to store the results
player_passing_types_log <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'passing_types')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_passing_types_log <- bind_rows(player_passing_types_log, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_passing_types_log)
View(unique(player_passing_types_log$Player))
length(unique(player_passing_types_log$Player))
write.csv(player_passing_types_log, file = "/Users/mac/R-footballscripts/players_matchlog/player_passing_types_log.csv", row.names = FALSE)

#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
7 -- gca logs

# Empty dataframe to store the results
player_gca_log2 <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'gca')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_gca_log2 <- bind_rows(player_gca_log2, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_gca_log2)
View(unique(player_gca_log2$Player))
length(unique(player_gca_log2$Player))
write.csv(player_gca_log2, file = "/Users/mac/R-footballscripts/players_matchlog/player_gca_log2.csv", row.names = FALSE)



#---------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------
######################################################################################################
8 -- keepers logs

# Empty dataframe to store the results
player_keepers_log <- data.frame()

# Loop through each URL
for (url in setdiff(urls, exclude)) {
  # Split the URL into individual elements
  url_elements <- unlist(strsplit(url, " "))
  
  # Loop through each element of the split URL
  for (element in url_elements) {
    # Try to get the match log data for the current URL element
    match_log <- try({
      fb_player_match_logs(element, season_end_year = 2023, stat_type = 'keepers')
    })
    
    # Check if the match log data was successfully retrieved
    if (!inherits(match_log, "try-error")) {
      # If successful, combine the data with the existing dataframe
      player_keepers_log <- bind_rows(player_keepers_log, match_log)
    } else {
      # If there was an error, print a message
      cat("Error retrieving match log for URL:", element, "\n")
    }
  }
}

# View the combined dataframe
View(player_keepers_log)
View(unique(player_keepers_log$Player))
length(unique(player_keepers_log$Player))
write.csv(player_keepers_log, file = "/Users/mac/R-footballscripts/players_matchlog/player_keepers_log.csv", row.names = FALSE)






