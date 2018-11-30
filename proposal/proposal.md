Building the Perfect Football Player
================
Team Devils
11/28/2018

## Section 1. Introduction

What makes the most valuable soccer player? We wish to explore how
performance, physical attributes, and general characteristics of soccer
players affect their market value during a season. Through
visualizations and modeling, we hope to explore each characteristic is
correlated to performance and market value for a player, and whether
patterns exist within goals, assists, age ranges, positions, and more,
among the top footballers. We plan to first use visualizations to
discover patterns, and then modeling to develop our central questions of
which characteristics of players impact performance and value. In order
to answer our question, we plan to construct a model which predicts the
relative market value of any player in the European club league.

Our data is a collection of the top 500 valuable players in the
2018-2019 European club season (data collected on 11/27/2018). The data
comes from a professional German soccer statistics website titled
“Transfermarkt”, which is a website dedicated to tracking player’s
market values and performances. Transfermarkt.com is a leading medium in
reporting soccer transfer news and they have connections with all of the
major leagues and clubs across Europe, South America, and Asia. The
player statistics are generated after each match and analyzed by
professional scouts and soccer analysts. Each observation is a player,
and includes the variables name, position, number of matches, number of
goals scored, number of own goals, number of assists, number of yellow
cards, number of red cards, number of substitutions on, number of
substitutions off, and market value. The data was obtained from
transfermarkt.com through web scraping tools learned from the course,
and the script used to scrape the data `(web_scrape.R)` can be found in
this repository. We currently have 12 columns and 50 rows scraped, but
may later during our analysis decide to obtain a few more columns and
several more rows, depending on where our analysis leads us.

## Section 2. Data analysis plan

## Variables

Here we use 11 variables as predictors (position, age, matches, goals,
own\_goals, assists, yellow\_cards, red\_cards, substituted\_on,
substituted\_off). These variables are used to predict the final outcome
variable —- market\_value. The meanings of all variables are explained
in the codebook in README.

## Statistical Methods

Since this is not a random sample, we will not do hypotheses testing.
Instead, we would like to come to a prediction rule on players’ market
value based on given variables. First since the variables that show
significant correlation, we will calculate a preliminary confidence
interval of the players’ general performances based on statistics using
bootstrapping. Then, we will make a model for `market_value`, using all
of the explanatory variables and the possible interactions between them
(e.g. the interaction between `position` and `goals` because common
knowledge tells us that there will be a correlation between the two). If
we can obtain the proper data for comparison, we also plan to compare
our model of player’s market value with historical data so that we can
obtain the trend of transfer markets. We will test the final model on
partitions of our data to evaluate it, and in the end attempt to come up
with a generalization about the conditions that will produce the highest
market value.

    ## Parsed with column specification:
    ## cols(
    ##   name = col_character(),
    ##   position = col_character(),
    ##   age = col_integer(),
    ##   matches = col_integer(),
    ##   goals = col_integer(),
    ##   own_goals = col_integer(),
    ##   assists = col_integer(),
    ##   yellow_cards = col_integer(),
    ##   red_cards = col_integer(),
    ##   substituted_on = col_integer(),
    ##   substituted_off = col_integer(),
    ##   market_value = col_double(),
    ##   age_range = col_character()
    ## )

### Summary Statistics

We can see that the most common position among the top 500 players is
Central Midfield. The least common positions are Left Midfield and Right
Midfield.

    ## # A tibble: 13 x 2
    ##    position               n
    ##    <chr>              <int>
    ##  1 Attacking Midfield    40
    ##  2 Central Midfield      83
    ##  3 Centre-Back           82
    ##  4 Centre-Forward        71
    ##  5 Defensive Midfield    38
    ##  6 Goalkeeper            22
    ##  7 Left Midfield          2
    ##  8 Left Winger           49
    ##  9 Left-Back             30
    ## 10 Right Midfield         2
    ## 11 Right Winger          47
    ## 12 Right-Back            26
    ## 13 Second Striker         8

We have tried to classify the players by age. Most players age between
21 and 25. There are 33 players above 30 years old and there are also 26
players who are younger than 20.

    ## # A tibble: 4 x 2
    ##   age_range        n
    ##   <chr>        <int>
    ## 1 20 and under    26
    ## 2 21-25          248
    ## 3 26-30          193
    ## 4 30 and above    33

The average matches played during season 2018-2019 so far by these top
500 players is 15.10 and the standard deviation is 5.78. The average
goals scored during season 2018-2019 so far by these top 500 players is
2.55 and the standard deviation is 3.24. The average assists made during
season 2018-2019 so far by these top 500 players is 1.87 and the
standard deviation is 2.15.

    ## # A tibble: 1 x 6
    ##   mean_matches sd_matches mean_goals sd_goals mean_assists sd_assists
    ##          <dbl>      <dbl>      <dbl>    <dbl>        <dbl>      <dbl>
    ## 1         15.6       5.97       2.61     3.33         1.92       2.21

Yellow card and red card are good indicators of players’ performance on
the field. They are given by referee to the players when players foul or
exhibit behaviors against sport morals. If a player gets two yellow
cards in a row in a match, he will be given a red card and expelled out
of the field. We can see that until now, 368 among the 500 players have
got yellow cards during season 2018-2019, and the maximum yellow card
number is 9, made by Nicolás Tagliafico.

    ## # A tibble: 9 x 2
    ##   yellow_cards     n
    ##          <int> <int>
    ## 1            0   129
    ## 2            1   110
    ## 3            2   101
    ## 4            3    64
    ## 5            4    50
    ## 6            5    27
    ## 7            6    15
    ## 8            7     3
    ## 9            9     1

    ## # A tibble: 1 x 1
    ##   name              
    ##   <chr>             
    ## 1 Nicolás Tagliafico

In season 2018-2019 thus far, there are 18 players who have already
gotten a red card in a match, meaning they are to be expelled for the
game.

    ## # A tibble: 18 x 2
    ##    name                red_cards
    ##    <chr>                   <int>
    ##  1 Kylian Mbappé               1
    ##  2 Cristiano Ronaldo           1
    ##  3 Marcus Rashford             1
    ##  4 Douglas Costa               1
    ##  5 Gonzalo Higuaín             1
    ##  6 Richarlison                 1
    ##  7 Clément Lenglet             1
    ##  8 Presnel Kimpembe            1
    ##  9 Hugo Lloris                 1
    ## 10 Abdou Diallo                1
    ## 11 Danilo Pereira              1
    ## 12 Matija Nastasic             1
    ## 13 Jamie Vardy                 1
    ## 14 Dani Parejo                 1
    ## 15 Samu Castillejo             1
    ## 16 Grzegorz Krychowiak         1
    ## 17 Jordan Amavi                1
    ## 18 Theo Hernández              1

In the dataset, the maximum player value is 180 million euros and the
minimum player value is 15 million euros. There are 13 players in the
dataset with a market value higher than 100 million euros.

    ## # A tibble: 1 x 2
    ##   max_value min_value
    ##       <dbl>     <dbl>
    ## 1       180        15

    ## # A tibble: 1 x 1
    ##   value_above_100m
    ##              <int>
    ## 1               13

### Visualizations

As can be seen in the plot below, the centre forward players on average
scored the most goals and the goalkeeper scored 0 goals. This makes
sense because it would be very unlikely for a goalkeeper to score a
goal.

![](proposal_files/figure-gfm/position_goals-1.png)<!-- -->

In the plot below, the right winger on average has the highest market
value and the left midfield players on average has the lowest market
value.

![](proposal_files/figure-gfm/position_value-1.png)<!-- -->

In the histogram below, we can see that the distribution of the players’
market values in the 2018-2019 season is right skewed.

![](proposal_files/figure-gfm/histogram-1.png)<!-- -->

## Expected Results

We expect the variables `goals`, `position`, `matches` and `assists` to
have the most impact on the player’s market value based on our prior
knowledge about football, and based on the visualizations above.

## Section 3. Data

Here we will glimpse the dataframe and view its dimensions. The
dimensions of our data frame, with the addition of the age range
variable, are 500 observations x 13 variables.

    ## Observations: 500
    ## Variables: 13
    ## $ name            <chr> "Kylian Mbappé", "Neymar", "Lionel Messi", "Mo...
    ## $ position        <chr> "Right Winger", "Left Winger", "Right Winger",...
    ## $ age             <int> 19, 26, 31, 26, 25, 27, 27, 26, 27, 25, 22, 25...
    ## $ matches         <int> 20, 23, 15, 19, 23, 25, 5, 21, 21, 20, 15, 21,...
    ## $ goals           <int> 15, 17, 15, 9, 12, 9, 0, 6, 10, 7, 3, 9, 10, 1...
    ## $ own_goals       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    ## $ assists         <int> 8, 13, 8, 4, 4, 6, 1, 4, 5, 3, 3, 3, 7, 2, 7, ...
    ## $ yellow_cards    <int> 4, 6, 1, 0, 4, 4, 1, 1, 2, 2, 0, 2, 0, 0, 2, 5...
    ## $ red_cards       <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0...
    ## $ substituted_on  <int> 3, 1, 1, 1, 1, 0, 3, 4, 5, 4, 3, 4, 0, 3, 8, 3...
    ## $ substituted_off <int> 4, 6, 1, 7, 4, 9, 2, 11, 6, 7, 4, 2, 0, 4, 6, ...
    ## $ market_value    <dbl> 180, 180, 180, 150, 150, 150, 150, 150, 150, 1...
    ## $ age_range       <chr> "20 and under", "26-30", "30 and above", "26-3...

    ## [1] 500  13
