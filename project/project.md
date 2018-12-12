Building the Perfect Soccer Player
================
team-devils
Dec 14, 2018

## Introduction

## Data Analysis

To get a general sense of the market values of all players in the
2018-2019 season, let’s first create a histogram to visualize their
distribution.

``` r
players1 %>%
  ggplot(mapping = aes(market_value, fill = ..count..)) +
  geom_histogram(binwidth = 5) +
  labs(
    title = "Distribution of Player Market Values in 2018-2019 Season",
    x = "Player Market Values in 2018-2019 season", 
    y = "Count"
  ) +
  theme_minimal() +
  scale_fill_gradient(low="blue", high="red")
```

![](project_files/figure-gfm/histogram-1.png)<!-- -->

The histogram appears to be right-skewed, so we decide to perform a log
transformation on the market value of players. The resulting histogram
(see below) is more normally distributed. Therefore, we will adhere to
this log transformation model in the following discussion.

``` r
players1 %>%
  ggplot(mapping = aes(log(market_value), fill = ..count..)) +
  geom_histogram(binwidth = 0.1) +
  labs(
    title = "Distribution of Player Market Values in 2018-2019 Season",
    x = "Player Market Values in 2018-2019 season", 
    y = "Count"
  ) +
  theme_minimal() +
  scale_fill_gradient(low="blue", high="red")
```

![](project_files/figure-gfm/log_histogram-1.png)<!-- -->

In the histogram above, we can see that the distribution of the players’
market values in the 2018-2019 season is right skewed, and that the most
commonly occuring market values are slightly less than $25 million. In
the summary statistics below, we can see that the mean of the market
values is higher than the most commonly occuring market values due to
the right skewedness of the data.

``` r
players1 %>%
  summarise(mean = mean(market_value), median = median(market_value), sd = sd(market_value), min = min(market_value), max = max(market_value))
```

    ## # A tibble: 1 x 5
    ##    mean median    sd   min   max
    ##   <dbl>  <dbl> <dbl> <dbl> <dbl>
    ## 1  35.3     25  25.2    15   180

The median, however, seems to be affected to a lesser extent by the high
valued outliers, and we can see this in the boxplot below.

``` r
players1 %>%
  ggplot(mapping = aes(y = market_value)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Boxplot of Player Market Values in 2018-2019 Season",
    y = "Player Market Values in 2018-2019 season"
  ) +
  theme_minimal() 
```

![](project_files/figure-gfm/boxplot-1.png)<!-- -->

``` r
players1 %>%
  select(name, market_value) %>%
  filter(market_value > 80)
```

    ## # A tibble: 22 x 2
    ##    name              market_value
    ##    <chr>                    <dbl>
    ##  1 Kylian Mbappé              180
    ##  2 Neymar                     180
    ##  3 Lionel Messi               180
    ##  4 Mohamed Salah              150
    ##  5 Harry Kane                 150
    ##  6 Antoine Griezmann          150
    ##  7 Kevin De Bruyne            150
    ##  8 Philippe Coutinho          150
    ##  9 Eden Hazard                150
    ## 10 Paulo Dybala               110
    ## # ... with 12 more rows

The previous table shows the outliers of the data. The following players
are extremely high market value players compared to the rest of the
players.

We condensed our data of 13 player positions to 4: Defender, Forward,
Goalkeeper, and Midfielder. We found the average goals made by each
position and average assists made by each position. It can be expected
that players who play Forward are most likely to score and assist goals,
Midfielders are the second most likely, followed by Defenders, and the
least most likely to score and assist goals are the Goalies.

``` r
players1 %>%
  group_by(position_new) %>%
  summarise(goals_avg = mean(goals))
```

    ## # A tibble: 4 x 2
    ##   position_new goals_avg
    ##   <chr>            <dbl>
    ## 1 Defender         0.797
    ## 2 Forward          5.61 
    ## 3 Goalkeeper       0    
    ## 4 Midfielder       2.14

``` r
players1 %>%
  group_by(position_new) %>%
  summarise(assists_avg = mean(assists))
```

    ## # A tibble: 4 x 2
    ##   position_new assists_avg
    ##   <chr>              <dbl>
    ## 1 Defender          1.27  
    ## 2 Forward           3.19  
    ## 3 Goalkeeper        0.0455
    ## 4 Midfielder        2.01

``` r
linear_prediction  <- lm(log(market_value) ~ position_new + age + matches + goals + own_goals +
                  assists + yellow_cards + red_cards + substituted_on +
                  substituted_off + age_range + position_new * goals + position_new * assists, data =   players1)
tidy(linear_prediction)
```

    ## # A tibble: 21 x 5
    ##    term                   estimate std.error statistic  p.value
    ##    <chr>                     <dbl>     <dbl>     <dbl>    <dbl>
    ##  1 (Intercept)              2.37     0.331       7.16  3.02e-12
    ##  2 position_newForward     -0.227    0.0975     -2.33  2.04e- 2
    ##  3 position_newGoalkeeper   0.0537   0.124       0.433 6.65e- 1
    ##  4 position_newMidfielder   0.118    0.0804      1.46  1.44e- 1
    ##  5 age                      0.0206   0.0158      1.31  1.92e- 1
    ##  6 matches                  0.0209   0.00472     4.43  1.15e- 5
    ##  7 goals                    0.0543   0.0358      1.52  1.30e- 1
    ##  8 own_goals               -0.0172   0.122      -0.141 8.88e- 1
    ##  9 assists                  0.0160   0.0240      0.667 5.05e- 1
    ## 10 yellow_cards            -0.0149   0.0129     -1.16  2.48e- 1
    ## # ... with 11 more rows

To begin with, we try to make a multiple linear regression based on all
the statistical variables we have in the players dataset. In soccer,
player’s position is highly correlated with his performances, especially
goals and assists (e.g. Centre-Forwards get most goals and Midfielders
make most assists in general while Goalkeepers can seldom score a goal
or make an assist). Therefore, we managed to introduce two interactions
between position/goals and position/assists into our multiple linear
model.

``` r
tidy(selected_model)
```

    ## # A tibble: 14 x 5
    ##    term                           estimate std.error statistic  p.value
    ##    <chr>                             <dbl>     <dbl>     <dbl>    <dbl>
    ##  1 (Intercept)                      2.36     0.327       7.23  1.93e-12
    ##  2 position_newForward             -0.262    0.0766     -3.42  6.76e- 4
    ##  3 position_newGoalkeeper           0.0961   0.114       0.841 4.01e- 1
    ##  4 position_newMidfielder           0.0584   0.0710      0.822 4.11e- 1
    ##  5 age                              0.0228   0.0157      1.46  1.45e- 1
    ##  6 matches                          0.0172   0.00385     4.46  1.01e- 5
    ##  7 goals                            0.0405   0.00826     4.90  1.32e- 6
    ##  8 assists                          0.0199   0.0237      0.837 4.03e- 1
    ##  9 age_range21-25                   0.0644   0.114       0.565 5.73e- 1
    ## 10 age_range26-30                   0.0789   0.164       0.481 6.31e- 1
    ## 11 age_range30 and above           -0.200    0.225      -0.889 3.75e- 1
    ## 12 position_newForward:assists      0.0459   0.0272      1.69  9.14e- 2
    ## 13 position_newGoalkeeper:assists   0.587    0.477       1.23  2.20e- 1
    ## 14 position_newMidfielder:assists  -0.0405   0.0298     -1.36  1.75e- 1

``` r
glance(linear_prediction)$AIC
```

    ## [1] 674.5785

``` r
glance(selected_model)$AIC
```

    ## [1] 666.3359

Through the model selection based on AIC, we can see that the variables
“own\_goals”, “yellow\_cards”, “red\_cards”, “substituted\_on”,
“substituted\_off”, and the interaction between “position\_new” and
“goals” are eliminated. The AIC is reduced compared to the previous
dataset (674.5785 to 666.3359), which can be interpreted as the
increased likelihood of the model.

``` r
glance(selected_model)$r.squared
```

    ## [1] 0.2578942

``` r
test_cv <- crossv_kfold(players1, 10)
models <- map(test_cv$train, ~ selected_model)
rmses <- map2_dbl(models, test_cv$test, rmse)
rmses
```

    ##         1         2         3         4         5         6         7 
    ## 0.4579047 0.4271696 0.5163594 0.5121771 0.4277472 0.4550118 0.4716433 
    ##         8         9        10 
    ## 0.4620550 0.3788731 0.4470545

## Conclusion

Your project goes here\! Before you submit, make sure your chunks are
turned off with `echo = FALSE`.

You can add sections as you see fit. Make sure you have a section called
Introduction at the beginning and a section called Conclusion at the
end. The rest is up to you\!
