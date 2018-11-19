library(tidyverse)
library(rvest)
library(lubridate)

page <- read_html("https://www.transfermarkt.com/spieler-statistik/wertvollstespieler/marktwertetop?land_id=0&ausrichtung=alle&spielerposition_id=alle&altersklasse=alle&jahrgang=0&plus=1")

name <- page %>%
  html_nodes(".spielprofil_tooltip") %>%
  html_text()

position <- page %>%
  html_nodes(".inline-table tr+ tr td") %>%
  html_text()

age <- page %>%
  html_nodes("td:nth-child(3)") %>%
  html_text() %>%
  as.numeric()

matches <- page %>%
  html_nodes(".hauptlink+ .zentriert") %>%
  html_text() %>%
  as.numeric()

goals <- page %>%
  html_nodes("td:nth-child(8)") %>%
  html_text() %>%
  as.numeric()

own_goals <- page %>%
  html_nodes("td:nth-child(9)") %>%
  html_text() %>%
  as.numeric()

assists <- page %>%
  html_nodes("td:nth-child(10)") %>%
  html_text() %>%
  as.numeric()

yellow_cards <- page %>%
  html_nodes("td:nth-child(11)") %>%
  html_text() %>%
  as.numeric()

red_cards <- page %>%
  html_nodes("td:nth-child(13)") %>%
  html_text() %>%
  as.numeric()

substituted_on <- page %>%
  html_nodes("td:nth-child(14)") %>%
  html_text() %>%
  as.numeric()

substituted_off <- page %>%
  html_nodes("td:nth-child(15)") %>%
  html_text() %>%
  as.numeric()

market_value <- page %>%
  html_nodes("#yw1 b") %>%
  html_text() %>%
  str_remove("Mill.") %>%
  str_remove("00") %>%
  str_remove("€") %>%
  str_remove_all(",") %>%
  str_trim() %>%
  as.numeric()
market_value

players1 <- tibble(
  name = name,
  position = position,
  age = age,
  matches = matches,
  goals = goals,
  own_goals = own_goals,
  assists = assists,
  yellow_cards = yellow_cards,
  red_cards = red_cards,
  substituted_on = substituted_on,
  substituted_off = substituted_off,
  market_value = market_value
)

##page2 <- read_html("https://www.transfermarkt.com/spieler-statistik/wertvollstespieler/marktwertetop?land_id=0&ausrichtung=alle&spielerposition_id=alle&altersklasse=alle&jahrgang=0&plus=2")

name2 <- c("Raphael Varane", "Roberto Firmino", "Jan Oblak", "James Rodriguez", "Marc-Andre ter Stegen", " Christian Eriksen",
           "Sergio Busquets", "Robert Lewandowski", "Toni Kroos", "Sergio Aguero", "Pierre-Emerick Aubameyang", "Thomas Lemar",
           "Sadio Mane", "Samuel Umtiti", "Marco Verratti", "Koke", "Jordi Alba", "David de Gea", "Marcelo", "Luis Suarez",
           "Miralem Pjanic", "Ivan Rakitic", "Casemiro", "Naby Keita", "Marcus Rashford")

position2 <- c("Centre-Back", "Second Striker", "Goalkeeper", "Attacking Midfield", "Goalkeeper", "Attacking Midfield", "Defensive Midfield",
               "Centre-Forward", "Central Midfield", "Centre-Forward", "Centre-Forward", "Left Winger", "Left Winger", "Centre-Back",
               "Central Midfield", "Central Midfield", "Left-Back", "Goalkeeper", "Left-Back", "Centre-Forward", "Central Midfield", "Central Midfield",
               "Defensive Midfield", "Central Midfield", "Centre-Forward")

age2 <- c(25,27,25,27,26,26,30,30,28,30,29,23,26,25,26,26,29,28,30,31,28,30,26,23,21)

matches2 <- c(17,20,17,13,18,15,21,20,19,15,16,17,16,9,15,15,18,21,10,19,20,20,21,11,19)

goals2 <- c(0,5,0,4,0,3,0,15,2,11,9,1,7,0,0,3,2,0,3,11,3,3,1,0,5)

own_goals2 <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

assists2 <- c(0,2,0,4,0,4,0,5,3,3,1,2,1,1,1,1,8,0,1,7,2,3,0,0,2)

yellow_cards2 <- c(0,0,0,2,1,0,5,0,2,4,0,2,1,2,4,4,1,0,3,5,3,3,1,1,1)

red_cards2 <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1)

substituted_on2 <- c(1,4,0,4,0,3,2,0,0,1,4,5,0,1,1,2,1,0,0,1,0,2,2,5,6)

substituted_off2 <- c(2,7,0,8,0,1,5,4,2,10,9,8,5,1,9,0,0,1,2,3,13,3,7,4,8)

market_value2 <- c(80,80,80,80,80,80,80,80,80,80,75,70,70,70,70,70,70,70,70,70,70,70,70,65,65)

players2 <- tibble(
  name = name2,
  position = position2,
  age = age2,
  matches = matches2,
  goals = goals2,
  own_goals = own_goals2,
  assists = assists2,
  yellow_cards = yellow_cards2,
  red_cards = red_cards2,
  substituted_on = substituted_on2,
  substituted_off = substituted_off2,
  market_value = market_value2
)
players_combined <- rbind(players1,players2)

write_csv(players_combined, path = "data/players_combined.csv")
