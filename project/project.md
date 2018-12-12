Building the Perfect Soccer Player
================
team-devils
Dec 14, 2018

## Introduction

While soccer’s popularity may be somewhat subdued in the United States,
soccer is not only one of the most widely followed sports in the world,
but also a deeply significant shared cultural experience. According to
the Global World Research Index, 3.2 billion individuals across the
globe watched at least one portion of the 2018 FIFA World Cup. In July
of 2018, Portuguese forward Cristiano Ronaldo transferred from Spanish
club Real Madrid to Italian club Juventus in a €100 million deal. What
combination of factors led to this one soccer player’s multi-million
dollar evaluation? Our team aims to discover what makes the most
valuable soccer player. We will use data of players in the 2018-2019
season of the professional European club soccer league. We selected the
information of players in this league over others due to the fact that
besides the World Cup, the professional European league is the highest
watched and most widely analyzed league in the world. Through
visualizations exploring patterns between markers of success in the
sport of soccer (such as number of assists, number of goals, etc.),
markers of failure (such as number of substitutions off the playing
field, number of own goals, etc.), and market value. In order to answer
our central question, we plan to use linear regression and modeling to
assist us in creating the most valuable soccer player. Our data is a
collection of the top 500 most valuable players in the 2018-2019
European club season (data collected on 11/27/2018). We recognize that
by using the top 500 players by market value (which is in and of itself
a biased measure), we have a sample which is biased and may be right
skewed in terms of market value. We will not be conducting hypothesis
testing due to the former and we will explore possibly analyzing our
data after using a transformation to account for the latter. The data
comes from a professional German soccer statistics website titled
“Transfermarkt”, which is a website dedicated to tracking players’
market values and performances. Transfermarkt.com is a leading medium in
reporting soccer transfer news and they have connections with all of the
major leagues and clubs across Europe, South America, and Asia. The
player statistics are generated after each match and analyzed by
professional scouts, soccer analysts and data scientists. Each
observation is a player, and includes the variables name, position,
number of matches, number of goals scored, number of own goals, number
of assists, number of yellow cards, number of red cards, number of
substitutions on, number of substitutions off, and market value. The
data was obtained from transfermarkt.com through web scraping tools
learned from the course.

## Data Analysis

To get a general sense of the market values of all players in the
2018-2019 season, let’s first create a histogram to visualize their
distribution:

``` r
players1 %>%
  ggplot(mapping = aes(market_value, fill = ..count..)) +
  geom_histogram(binwidth = 5) +
  labs(
    title = "Distribution of Player Market Values in 2018-2019 Season",
    x = "Player Market Values in 2018-2019 Season", 
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
market values in the 2018-2019 season is right-skewed, and that the most
commonly occuring market value is around $23 million. In the summary
statistics below, we can see that the mean of the market values is
higher than the most commonly occuring market values due to the right
skewedness of the data:

``` r
players1 %>%
  summarise(mean = mean(market_value), median = median(market_value), sd = sd(market_value), min = min(market_value), max = max(market_value))
```

    ## # A tibble: 1 x 5
    ##    mean median    sd   min   max
    ##   <dbl>  <dbl> <dbl> <dbl> <dbl>
    ## 1  35.3     25  25.2    15   180

The median, however, seems to be affected to a lesser extent by the high
valued outliers. In the boxplot below, the blue colored line represents
the median, and the red line represents the mean:

``` r
players1 %>%
  ggplot(mapping = aes(y = market_value)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Boxplot of Player Market Values in 2018-2019 Season",
    y = "Player Market Values in 2018-2019 season"
  ) +
  theme_minimal() +
  geom_hline(yintercept = 35.3, color = "red") +
  geom_hline(yintercept = 25, color = "blue")
```

![](project_files/figure-gfm/boxplot-1.png)<!-- -->

``` r
# Coloring code found on http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
```

The boxplot also revealed that there are many outliers in the data. The
table below shows the names and market values of the outlying soccer
players:

``` r
players1 %>%
  select(name, market_value) %>%
  filter(market_value > 75) %>%
  kable()
```

| name                    | market\_value |
| :---------------------- | ------------: |
| Kylian Mbappé           |           180 |
| Neymar                  |           180 |
| Lionel Messi            |           180 |
| Mohamed Salah           |           150 |
| Harry Kane              |           150 |
| Antoine Griezmann       |           150 |
| Kevin De Bruyne         |           150 |
| Philippe Coutinho       |           150 |
| Eden Hazard             |           150 |
| Paulo Dybala            |           110 |
| Dele Alli               |           100 |
| Romelu Lukaku           |           100 |
| Cristiano Ronaldo       |           100 |
| Mauro Icardi            |            95 |
| Marco Asensio           |            90 |
| Sergej Milinkovic-Savic |            90 |
| Leroy Sané              |            90 |
| Saúl Níguez             |            90 |
| Raheem Sterling         |            90 |
| Paul Pogba              |            90 |
| Isco                    |            90 |
| Gareth Bale             |            90 |
| Gabriel Jesus           |            80 |
| Ousmane Dembélé         |            80 |
| N’Golo Kanté            |            80 |
| Raphaël Varane          |            80 |
| Roberto Firmino         |            80 |
| Jan Oblak               |            80 |
| James Rodríguez         |            80 |
| Marc-André ter Stegen   |            80 |
| Christian Eriksen       |            80 |
| Sergio Busquets         |            80 |
| Robert Lewandowski      |            80 |
| Toni Kroos              |            80 |
| Sergio Agüero           |            80 |

These players have extremely high market values compared to the rest of
the players. Which raises the question: do they contribute much more
than the other players? Let a player’s contribution be the sum of the
player’s goals and assists, the following boxplots compare the
contributions of the outlying players to that of the “normal” players:

``` r
players1 <- players1 %>%
  mutate(outlier = ifelse(
    market_value >75, T, F
  ), 
  contribution = goals + assists
  )

players1 %>%
  ggplot(mapping = aes(x = outlier, y = contribution, color = outlier)) +
  scale_color_manual(values = c("blue", "red")) +
  geom_boxplot() +
  labs(
    title = "Boxplot of Player Contributions in 2018-2019 Season",
    x = "Outlier (True/False)", 
    y = "Count"
  ) +
  guides(color = "none") +
  coord_flip() +
  theme_minimal() 
```

![](project_files/figure-gfm/outliers-plot-1.png)<!-- -->

We can see from the comparison above that the outlying soccer players
with very high market values do contribute significantly more, therefore
their high market value is justified.

Now we would like to investigate the relationship between a player’s
position and the number of goals they score. In order to reduce
confusion, we condensed our data of 13 player positions into 4:
Defender, Forward, Goalkeeper, and Midfielder. We found the average
goals made by each position and average assists made by each position:

``` r
position_goals <- players1 %>%
  group_by(position_new) %>%
  summarise(goals_avg = mean(goals), assists_avg = mean(assists))

position_goals
```

    ## # A tibble: 4 x 3
    ##   position_new goals_avg assists_avg
    ##   <chr>            <dbl>       <dbl>
    ## 1 Defender         0.797      1.27  
    ## 2 Forward          5.61       3.19  
    ## 3 Goalkeeper       0          0.0455
    ## 4 Midfielder       2.14       2.01

``` r
position_goals %>%
  mutate(position_new = fct_reorder(position_new, goals_avg)) %>%
  ggplot(mapping = aes(x = position_new, y = goals_avg)) +
  geom_col(fill = "blue") +
  labs(
    title = "Average Goals Scored in Each Position in the 2018-2019 Season",
    x = "Position", 
    y = "Average Goals Scored"
  ) +
  coord_flip() +
  theme_minimal()
```

![](project_files/figure-gfm/position-goals-1.png)<!-- -->

``` r
position_goals %>%
  mutate(position_new = fct_reorder(position_new, assists_avg)) %>%
  ggplot(mapping = aes(x = position_new, y = assists_avg)) +
  geom_col(fill = "purple") +
  labs(
    title = "Average Assists in Each Position in the 2018-2019 Season",
    x = "Position", 
    y = "Average Assists"
  ) +
  coord_flip() +
  theme_minimal()
```

![](project_files/figure-gfm/position-goals-2.png)<!-- -->

From the visualizations above, we can see that forward players have the
most goals and assists on average, followed by midfielder, defender and
goalkeeper. This is expected because forward players are the closest to
the goal of the opposing team, making them the most likely to score and
assist goals. Midfielders are the second closest, followed by defenders
and goalkeepers. Interestingly, the average assists for goalkeeper is
greater than 0. Let’s find out which goalkeeper assisted a goal:

``` r
players1 %>%
  select(name, position_new, assists) %>%
  filter(position_new == "Goalkeeper", assists > 0)
```

    ## # A tibble: 1 x 3
    ##   name    position_new assists
    ##   <chr>   <chr>          <int>
    ## 1 Ederson Goalkeeper         1

It looks like Ederson is the only goalkeeper who assisted a goal in the
2018-2019 season.

### Interactive Shiny App

``` r
shinyApp(

ui <- fluidPage(
  theme = shinytheme("cyborg"),
  titlePanel("Players browser"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "y",
        label = "Y-axis:",
        choices = c(
          "Position" = "position",
          "Age" = "age",
          "Matches" = "matches",
          "Goals" = "goals",
          "Own Goals" = "own_goals",
          "Assists" = "assists",
          "Yellow Cards" = "yellow_cards",
          "Red Cards" = "red_cards",
          "Substituted On" = "substituted_on",
          "Substituted Off" = "substituted_off",
          "Market Value" = "market_value",
          "Age Range" = "age_range"
        ),
        selected = "position"
      ),
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c(
          "Position" = "position",
          "Age" = "age",
          "Matches" = "matches",
          "Goals" = "goals",
          "Own Goals" = "own_goals",
          "Assists" = "assists",
          "Yellow Cards" = "yellow_cards",
          "Red Cards" = "red_cards",
          "Substituted On" = "substituted_on",
          "Substituted Off" = "substituted_off",
          "Market Value" = "market_value",
          "Age Range" = "age_range"
        ),
        selected = "market_value"
      ),
      selectInput(
        inputId = "z",
        label = "Color by:",
        choices = c(
          "Position" = "position",
          "Age" = "age",
          "Matches" = "matches",
          "Goals" = "goals",
          "Own Goals" = "own_goals",
          "Assists" = "assists",
          "Yellow Cards" = "yellow_cards",
          "Red Cards" = "red_cards",
          "Substituted On" = "substituted_on",
          "Substituted Off" = "substituted_off",
          "Market Value" = "market_value",
          "Age Range" = "age_range"
        ),
        selected = "age"
      )
    ),
    mainPanel(plotOutput(outputId = "scatterplot"))
  )
),

server <- function(input, output) {

  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = players1, aes_string(
      x = input$x, y = input$y,
      color = input$z
    )) +
      geom_point() +
      labs(
        x = toTitleCase(str_replace_all(input$x, "_", " ")),
        y = toTitleCase(str_replace_all(input$y, "_", " ")),
        color = toTitleCase(str_replace_all(input$z, "_", " "))
      )
  })
},

options = list(height = 500)
)
```

<!--html_preserve-->

<div class="muted well" style="width: 100% ; height: 500px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;">

Shiny applications not supported in static R Markdown
documents

</div>

<!--/html_preserve-->

### What Makes a Valuable Soccer Player?

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

<<<<<<< HEAD
    ##         1         2         3         4         5         6         7 
    ## 0.4579047 0.4271696 0.5163594 0.5121771 0.4277472 0.4550118 0.4716433 
    ##         8         9        10 
    ## 0.4620550 0.3788731 0.4470545
=======
    ##        1        2        3        4        5        6        7        8 
    ## 17.07693 19.91039 21.23318 25.79268 23.67975 20.50450 23.56914 20.98397 
    ##        9       10 
    ## 18.95159 18.75363
>>>>>>> 8a1c030c46ea560203b98706786fcd38ba09308b

## Conclusion

Your project goes here\! Before you submit, make sure your chunks are
turned off with `echo = FALSE`.

You can add sections as you see fit. Make sure you have a section called
Introduction at the beginning and a section called Conclusion at the
end. The rest is up to you\!
