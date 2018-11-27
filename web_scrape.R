library(tidyverse)
library(rvest)
library(lubridate)
library(RSelenium)

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
           "Miralem Pjanic", "Ivan Rakitic", "Casemiro", "Naby Keita", "Marcus Rashford", "Nabil Fekir", "Lorenzo Insigne",
           "Thibaut Courtois", "Alexandre Lacazette", "Bernardo Silva", "Ederson", "Anthony Martial", "Riyad Mahrez", "Timo Werner", 
           "Virgil van Dijk", "Daniel Carvajal", "Alvaro Morata", "Alisson", "Jorginho", "Kalidou Koulibaly", "Thiago", "Edinson Cavani",
           "Diego Costa", "Kai Havertz", "John Stones", "Marquinhos", "Joshua Kimmich", "Sergi Roberto", "Douglas Costa", "Alexis Sanchez",
           "Mats Hummels", "Gonzalo Higuain", "Arthur", "Federico Chiesa", "Matthijs de Ligt", "Lucas Hernandez", "Jose Gimenez", "Kingsley Coman",
           "Milan Skriniar", "Kepa", "Fred", "Florian Thauvin", "Adrien Rabiot", "Aymeric Laporte", "Niklas Sule", "Rodrigo", "Ciro Immobile",
           "Kyle Walker", "Heung-min Son", "David Alaba", "Thomas Muller", "Willian", "Jadon Sancho", "Leon Bailey", "Richarlison")

position2 <- c("Centre-Back", "Second Striker", "Goalkeeper", "Attacking Midfield", "Goalkeeper", "Attacking Midfield", "Defensive Midfield",
               "Centre-Forward", "Central Midfield", "Centre-Forward", "Centre-Forward", "Left Winger", "Left Winger", "Centre-Back",
               "Central Midfield", "Central Midfield", "Left-Back", "Goalkeeper", "Left-Back", "Centre-Forward", "Central Midfield", "Central Midfield",
               "Defensive Midfield", "Central Midfield", "Centre-Forward", "Attacking Midfield", "Left Winger", "Goalkeeper", "Centre-Forward", "Right Winger",
               "Goalkeeper", "Left Winger", "Right Winger", "Centre-Forward", "Centre-Back", "Right-Back", "Centre-Forward", "Goalkeeper", "Defensive Midfield", "Centre-Back",
               "Central Midfield", "Centre-Forward", "Centre-Forward", "Attacking Midfield", "Centre-Back", "Centre-Back", "Right-Back", "Right-Back", "Right Winger",
               "Left Winger", "Centre-Back", "Centre-Forward", "Central Midfield", "Right Winger", "Centre-Back", "Left-Back", "Centre-Back", "Left Winger", "Centre-Back",
               "Goalkeeper", "Central Midfield", "Right Winger", "Central Midfield", "Centre-Back", "Centre-Back", "Centre-Forward", "Centre-Forward", "Right-Back", "Left Winger",
               "Left-Back", "Second Striker", "Right Winger", "Left Winger", "Left Winger", "Left Winger")

age2 <- c(25,27,25,27,26,26,30,30,28,30,29,23,26,25,26,26,29,28,30,31,28,30,26,23,21,25,27,26,27,24,25,22,27,22,27,26,26,26,26,27,27,31,30,19,24,24,23,26,28,29,
          29,30,22,21,19,22,23,22,23,24,25,25,23,24,23,27,28,28,26,26,29,30,18,21,21)

matches2 <- c(17,20,17,13,18,15,21,20,19,15,16,17,16,9,15,15,18,21,10,19,20,20,21,11,19,
              13,20,17,15,21,19,15,19,21,22,11,21,20,21,17,17,17,14,19,20,22,25,16,15,15,
              17,13,21,19,28,16,11,3,20,19,12,17,17,18,19,22,20,20,24,21,24,23,23,16,18)

goals2 <- c(0,5,0,4,0,3,0,15,2,11,9,1,7,0,0,3,2,0,3,11,3,3,1,0,5,
            4,10,0,6,6,0,7,6,9,2,1,6,0,2,0,2,11,4,6,0,2,0,0,0,3,
            1,7,0,2,2,0,2,1,0,0,1,11,2,2,2,3,9,1,4,1,5,3,5,1,9)

own_goals2 <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0)

assists2 <- c(0,2,0,4,0,4,0,5,3,3,1,2,1,1,1,1,8,0,1,7,2,3,0,0,2,
              4,3,0,4,4,1,0,4,2,1,2,0,0,0,1,2,4,2,7,0,1,5,4,3,3,
              1,1,1,6,1,1,0,1,0,0,0,4,2,0,0,4,5,1,10,2,3,6,9,0,2)

yellow_cards2 <- c(0,0,0,2,1,0,5,0,2,4,0,2,1,2,4,4,1,0,3,5,3,3,1,1,1,
                   3,3,0,1,2,0,2,0,1,2,4,6,0,4,5,2,1,6,1,2,1,3,0,3,2,
                   3,4,2,5,1,4,2,0,5,0,2,3,3,1,1,2,3,1,2,1,1,1,1,2,1)

red_cards2 <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
                0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1)

substituted_on2 <- c(1,4,0,4,0,3,2,0,0,1,4,5,0,1,1,2,1,0,0,1,0,2,2,5,6,
                     3,1,0,6,3,0,3,9,2,0,1,5,0,0,0,2,1,0,1,3,1,1,2,9,5,
                     1,0,6,1,1,1,1,2,0,1,3,3,2,0,2,4,3,2,6,2,8,6,12,8,6)

substituted_off2 <- c(2,7,0,8,0,1,5,4,2,10,9,8,5,1,9,0,0,1,2,3,13,3,7,4,8,
                      7,7,0,1,4,0,3,6,10,1,2,9,0,4,0,2,4,6,4,3,1,0,2,7,6,
                      3,1,12,5,1,2,4,1,0,1,7,9,2,1,0,3,4,1,12,4,8,13,6,5,5)

market_value2 <- c(80,80,80,80,80,80,80,80,80,80,75,70,70,70,70,70,70,70,70,70,70,70,70,65,65,
                   65,65,65,65,60,60,60,60,60,60,60,60,60,60,60,60,60,60,55,55,55,55,55,55,55,
                   55,55,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,45,45,45)

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
