Football Exploration
================
team-devils
9/19/2018

## Section 1. Introduction

We wish to explore how performance, physical attributes, and general
characteristics of soccer players impact their market value during a
season. Through visualizations and modeling, we hope to explore which
characteristics are more and less determinant of strong performance and
market value for a player, and whether patterns exist within
nationalities, teams, age ranges, positions, and more. We plan to first
minimally use visualizations to discover patterns, and then modeling to
develop our central questions of which characteristics of players impact
performance and value.

Our data is a collection of the top 50 players in the 2018-2019 European
club season. The data comes from a German website titled
“Transfermarkt”, which is a website dedicated to tracking soccer
statistics. Each observation is a player, and includes the variables
name, position, number of matches, number of goals scored, number of own
goals, number of assists, number of yellow cards, number of red cards,
number of substitutions on, number of substitutions off, and market
value. The data was obtained from transfermarkt.com through web scraping
tools learned from the course, and the web\_scrape.R file can be found
in this R project. We currently have 12 columns and 50 rows scraped, but
may later during our analysis decide to obtain a few more columns and
several more rows, depending on where our analysis leads us.

## Section 2. Data analysis plan

    ## Observations: 50
    ## Variables: 12
    ## $ name            <fct> Kylian Mbappé, Neymar, Lionel Messi, Mohamed S...
    ## $ position        <fct> Right Winger, Left Winger, Right Winger, Right...
    ## $ age             <int> 19, 26, 31, 26, 25, 27, 27, 26, 27, 25, 22, 25...
    ## $ matches         <int> 18, 21, 13, 17, 21, 22, 5, 20, 20, 18, 13, 19,...
    ## $ goals           <int> 15, 16, 14, 8, 11, 8, 0, 6, 10, 6, 2, 9, 9, 10...
    ## $ own_goals       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    ## $ assists         <int> 8, 13, 6, 4, 4, 4, 1, 4, 5, 3, 1, 2, 6, 2, 7, ...
    ## $ yellow_cards    <int> 4, 5, 1, 0, 4, 1, 1, 1, 1, 2, 0, 2, 0, 0, 2, 4...
    ## $ red_cards       <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0...
    ## $ substituted_on  <int> 3, 1, 1, 1, 1, 0, 3, 4, 5, 3, 3, 3, 0, 2, 7, 3...
    ## $ substituted_off <int> 2, 5, 1, 6, 4, 8, 2, 10, 6, 6, 3, 2, 0, 3, 5, ...
    ## $ market_value    <int> 180, 180, 180, 150, 150, 150, 150, 150, 150, 1...

    ## # A tibble: 10 x 2
    ##    position               n
    ##    <fct>              <int>
    ##  1 Attacking Midfield     6
    ##  2 Central Midfield       9
    ##  3 Centre-Back            2
    ##  4 Centre-Forward        10
    ##  5 Defensive Midfield     3
    ##  6 Goalkeeper             3
    ##  7 Left Winger            8
    ##  8 Left-Back              2
    ##  9 Right Winger           5
    ## 10 Second Striker         2

We can see that the most common position among the top 50 players is
Centre-Forward. Most players are attackers or midfielders instead of
defenders.

``` r
players_combined <- players_combined %>%
  mutate(age_range = case_when(
    age>30  ~ "above 30",
    26<=age & age<=30     ~ "26-30",
    21<=age & age<=25     ~ "21-25",
    age<=20  ~ "under 20"
  ))
players_combined %>%
  count(age_range)
```

    ## # A tibble: 4 x 2
    ##   age_range     n
    ##   <chr>     <int>
    ## 1 21-25        19
    ## 2 26-30        27
    ## 3 above 30      3
    ## 4 under 20      1

We have tried to classify the players by age. Most players age between
26 and 30. There are 3 players above 30 years old and there’s also one
player who is younger than 20.

    ##   mean_matches
    ## 1        17.34

    ##   sd_matches
    ## 1    3.51446

The average matches played during season 2018-2019 by these top 50
players is 17.34 and the standard deviation is 3.51.

    ##   mean_goals
    ## 1       5.22

    ##   sd_goals
    ## 1 4.514331

The average goals scored during season 2018-2019 by these top 50 players
is 5.22 and the standard deviation is 4.51.

    ##   mean_assists
    ## 1         3.04

    ##   sd_assists
    ## 1   2.725241

The average assists made during season 2018-2019 by these top 50 players
is 3.04 and the standard deviation is 2.73.

    ## # A tibble: 6 x 2
    ##   yellow_cards     n
    ##          <int> <int>
    ## 1            0    12
    ## 2            1    15
    ## 3            2     9
    ## 4            3     4
    ## 5            4     7
    ## 6            5     3

We can see that until now, 38 among the 50 players have got yellow cards
during season 2018-2019, and the maximum yellow card number is
    5.

    ##                name       position age matches goals own_goals assists
    ## 1     Kylian Mbappé   Right Winger  19      18    15         0       8
    ## 2 Cristiano Ronaldo    Left Winger  33      15     9         0       6
    ## 3   Marcus Rashford Centre-Forward  21      19     5         0       2
    ##   yellow_cards red_cards substituted_on substituted_off market_value
    ## 1            4         1              3               2          180
    ## 2            0         1              0               0          100
    ## 3            1         1              6               8           65
    ##   age_range
    ## 1  under 20
    ## 2  above 30
    ## 3     21-25

In season 2018-2019, there are 3 players who have already got red card
in a match and being expelled: Kylian Mbappé, Cristiano Ronaldo, and
Marcus Rashford.

``` r
players_combined %>%
  summarise(max_value = max(market_value))
```

    ##   max_value
    ## 1       180

``` r
players_combined %>%
  summarise(min_value = min(market_value))
```

    ##   min_value
    ## 1        65

``` r
players_combined %>%
  filter(market_value>=100) %>%
  summarise(value_above_100m = n())
```

    ##   value_above_100m
    ## 1               13

In the dataset, the maximum player value is 180 million euro and the
minimum player value is 65 million euro. There are 13 players in the
dataset with a market value higher than 100 million euro.

## Section 3. Data
