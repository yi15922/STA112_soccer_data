Building the Perfect Football Player
================
Team Devils
9/19/2018

## Section 1. Introduction

What makes the most valuable soccer player? We wish to explore how
performance, physical attributes, and general characteristics of soccer
players impact their market value during a season. Through
visualizations and modeling, we hope to explore which characteristics
are more and less determinant of strong performance and market value for
a player, and whether patterns exist within goals, assists, age ranges,
positions, and more. We plan to first minimally use visualizations to
discover patterns, and then modeling to develop our central questions of
which characteristics of players impact performance and value. In order
to answer our question, we plan to construct a model which predicts the
relative market value of any player in the European club league.

Our data is a collection of the top 50 valuable players in the 2018-2019
European club season. The data comes from a professional German soccer
statistics website titled “Transfermarkt”, which is a website dedicated
to tracking player’s market values and performances. Transfermarkt.com
is a leading media in reporting soccer transfer news and they have
connections with all of the major leagues and clubs across Europe, South
America, and Asia. The player statistics are generated after each match
and analyzed by professional scouts and soccer analysts. Each
observation is a player, and includes the variables name, position,
number of matches, number of goals scored, number of own goals, number
of assists, number of yellow cards, number of red cards, number of
substitutions on, number of substitutions off, and market value. The
data was obtained from transfermarkt.com through web scraping tools
learned from the course, and the web\_scrape.R file can be found in this
R project. We currently have 12 columns and 50 rows scraped, but may
later during our analysis decide to obtain a few more columns and
several more rows, depending on where our analysis leads us.

## Section 2. Data analysis plan

## Variables

Here we use 11 variables as predictors (position, age, matches, goals,
own\_goals, assists, yellow\_cards, red\_cards, substituted\_on,
substituted\_off). These variables are used to predict the final outcome
variable —- market\_value. The meanings of all variables are explained
in the codebook in README.

## Statistical Methods

We will first test to see if each variable makes a significant
difference in the market value of a player using hypotheses testing. For
the variables that show significant correlation, we will also calculate
a confidence interval using bootstrapping. Then, we will make a model
for `market_value`, using all of the explanatory variables and the
possible interactions between them (e.g. the interaction between
`position` and `goals` because common knowledge tells us that there will
be a correlation between the two). After we make the model, we will
perform a backwards selection to remove the unnecessary variables. If we
can obtain the proper data for comparison, we also plan to compare our
model of player’s market value with historical data so that we can
obtain the trend of transfer markets. We will test the final model on
partitions of our data to evaluate it, and in the end attempt to come up
with a generalization about the conditions that will produce the highest
market value.

### Summary Statistics

    ## # A tibble: 11 x 2
    ##    position               n
    ##    <fct>              <int>
    ##  1 Attacking Midfield     8
    ##  2 Central Midfield      13
    ##  3 Centre-Back           12
    ##  4 Centre-Forward        18
    ##  5 Defensive Midfield     4
    ##  6 Goalkeeper             7
    ##  7 Left Winger           16
    ##  8 Left-Back              4
    ##  9 Right Winger          11
    ## 10 Right-Back             4
    ## 11 Second Striker         3

We can see that the most common position among the top 50 players is
Centre-Forward. Most players are attackers or midfielders instead of
defenders.

    ## # A tibble: 4 x 2
    ##   age_range     n
    ##   <chr>     <int>
    ## 1 21-25        41
    ## 2 26-30        51
    ## 3 above 30      4
    ## 4 under 20      4

We have tried to classify the players by age. Most players age between
26 and 30. There are 3 players above 30 years old and there’s also one
player who is younger than
    20.

    ##   mean_matches sd_matches mean_goals sd_goals mean_assists sd_assists
    ## 1        18.09   3.979988       4.33 4.124465         2.74   2.615494

The average matches played during season 2018-2019 thus far by these top
50 players is 17.34 and the standard deviation is 3.51. The average
goals scored during season 2018-2019 thus far by these top 50 players is
5.22 and the standard deviation is 4.51. The average assists made during
season 2018-2019 thus far by these top 50 players is 3.04 and the
standard deviation is 2.73.

    ## # A tibble: 7 x 2
    ##   yellow_cards     n
    ##          <int> <int>
    ## 1            0    19
    ## 2            1    27
    ## 3            2    21
    ## 4            3    13
    ## 5            4    11
    ## 6            5     7
    ## 7            6     2

We can see that until now, 38 among the 50 players have got yellow cards
during season 2018-2019, and the maximum yellow card number is 5.

    ##                name red_cards
    ## 1     Kylian Mbappé         1
    ## 2 Cristiano Ronaldo         1
    ## 3   Marcus Rashford         1
    ## 4     Douglas Costa         1
    ## 5   Gonzalo Higuain         1
    ## 6       Richarlison         1

In season 2018-2019 thus far, there are 3 players who have already
gotten a red card in a match, meaning they are to be expelled for the
game: Kylian Mbappé, Cristiano Ronaldo, and Marcus Rashford.

    ##   max_value min_value
    ## 1       180        45

    ##   value_above_100m
    ## 1               13

In the dataset, the maximum player value is 180 million euros and the
minimum player value is 65 million euros. There are 13 players in the
dataset with a market value higher than 100 million euros.

### Visualizations

![](proposal_files/figure-gfm/position_goals-1.png)<!-- -->

As can be seen from this plot, the centre forward players scored the
most goals and the goalkeeper and centre back players scored 0 goals.
This makes sense because it would be very unlikely for a defense player
or goalkeeper to get close enough to score a goal.

![](proposal_files/figure-gfm/position_value-1.png)<!-- -->

Based on this plot, the right winger on average has the highest market
value and the left back players on average has the lowest market value.

## Expected Results

We expect the variables `goals`, `position`, `matches` and `assists` to
have the most impact on the player’s market value based on our prior
knowledge about football, and based on the visualizations above.

## Section 3. Data

Here we will glimpse the dataframe and view its dimensions. The
dimensions of our data frame, with the addition of the age range
variable, are 50 observations x 13 variables.

    ## Observations: 100
    ## Variables: 13
    ## $ name            <fct> Kylian Mbappé, Neymar, Lionel Messi, Mohamed S...
    ## $ position        <fct> Right Winger, Left Winger, Right Winger, Right...
    ## $ age             <int> 19, 26, 31, 26, 25, 27, 27, 26, 27, 25, 22, 25...
    ## $ matches         <int> 19, 22, 14, 18, 22, 24, 5, 20, 21, 19, 14, 20,...
    ## $ goals           <int> 15, 16, 14, 9, 12, 8, 0, 6, 10, 7, 3, 9, 10, 1...
    ## $ own_goals       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    ## $ assists         <int> 8, 13, 7, 4, 4, 5, 1, 4, 5, 3, 2, 2, 6, 2, 7, ...
    ## $ yellow_cards    <int> 4, 5, 1, 0, 4, 3, 1, 1, 2, 2, 0, 2, 0, 0, 2, 5...
    ## $ red_cards       <int> 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0...
    ## $ substituted_on  <int> 3, 1, 1, 1, 1, 0, 3, 4, 5, 4, 3, 3, 0, 3, 7, 3...
    ## $ substituted_off <int> 3, 6, 1, 7, 4, 9, 2, 10, 6, 6, 4, 2, 0, 4, 6, ...
    ## $ market_value    <int> 180, 180, 180, 150, 150, 150, 150, 150, 150, 1...
    ## $ age_range       <chr> "under 20", "26-30", "above 30", "26-30", "21-...

    ## [1] 100  13
