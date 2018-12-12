library(tidyverse)
library(rvest)

page <- read_html("https://www.transfermarkt.com/spieler-statistik/wertvollstespieler/marktwertetop?land_id=0&ausrichtung=alle&spielerposition_id=alle&altersklasse=alle&jahrgang=0&plus=1&page=1")

name <- page %>%
  html_nodes(".spielprofil_tooltip") %>%
  html_text()
name

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

for(i in 1:20) {
  page <- read_html(paste0("https://www.transfermarkt.com/spieler-statistik/wertvollstespieler/marktwertetop?land_id=0&ausrichtung=alle&spielerposition_id=alle&altersklasse=alle&jahrgang=0&plus=1&page=",i))
  
  name <- page %>%
    html_nodes(".spielprofil_tooltip") %>%
    html_text()
  name
  
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
    str_remove("€") %>%
    str_remove_all(",") %>%
    str_trim() %>%
    as.numeric()
  
  players <- tibble(
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
  
  players1 <- rbind(players1, players)
}

players1 <- players1 %>%
  filter(market_value>=1000) %>%
  mutate(market_value = market_value/100)

# Creating new variable with condensed positions

players1 <- players1 %>%
  mutate(position_new = case_when(
    position == "Centre-Forward" | position == "Left Winger" | 
    position == "Right Winger" |  position == "Second Striker"  ~ "Forward",
    position == "Attacking Midfield" | position == "Central Midfield" |
    position == "Defensive Midfield" | position == "Left Midfield" |
    position == "Right Midfield"  ~ "Midfielder",
    position == "Centre-Back"  | position == "Left-Back"  |
    position == "Right-Back"   ~ "Defender",
    position == "Goalkeeper"  ~  "Goalkeeper"
  ))

write_csv(players1, path = "data/players1.csv")
