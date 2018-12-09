PROJECT TITLE
================
TEAM NAME
TODAY’S DATE

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

    ## # A tibble: 46 x 5
    ##    term                       estimate std.error statistic p.value
    ##    <chr>                         <dbl>     <dbl>     <dbl>   <dbl>
    ##  1 (Intercept)                   18.1      16.6      1.09  0.274  
    ##  2 positionCentral Midfield      -8.09      6.70    -1.21  0.228  
    ##  3 positionCentre-Back          -10.8       6.54    -1.66  0.0986 
    ##  4 positionCentre-Forward       -23.1       7.59    -3.04  0.00252
    ##  5 positionDefensive Midfield    -5.12      7.48    -0.685 0.494  
    ##  6 positionGoalkeeper            -8.49      7.99    -1.06  0.288  
    ##  7 positionLeft Midfield        -22.4      22.5     -0.999 0.318  
    ##  8 positionLeft Winger          -21.4       7.51    -2.84  0.00464
    ##  9 positionLeft-Back            -18.2       8.93    -2.03  0.0427 
    ## 10 positionRight Midfield        11.8      22.3      0.528 0.598  
    ## # ... with 36 more rows

To begin with, we try to make a multiple linear regression based on all
the statistical variables we have in the players dataset. In soccer,
player’s position is highly correlated with his performances, especially
goals and assists (e.g. Centre-Forwards get most goals and Midfielders
make most assists in general while Goalkeepers can seldom score a goal
or make an assist). Therefore, we managed to introduce two interactions
between position/goals and position/assists into our multiple linear
model.

    ## Start:  AIC=3113.9
    ## market_value ~ position + age + matches + goals + own_goals + 
    ##     assists + yellow_cards + red_cards + substituted_on + substituted_off + 
    ##     age_range + position * goals + position * assists
    ## 
    ##                    Df Sum of Sq    RSS    AIC
    ## - position:assists 10    4537.8 215282 3104.6
    ## - age               1      71.9 210816 3112.1
    ## - own_goals         1      74.4 210818 3112.1
    ## - yellow_cards      1      82.1 210826 3112.1
    ## - substituted_off   1     152.0 210896 3112.3
    ## - substituted_on    1     436.2 211180 3112.9
    ## - red_cards         1     511.9 211256 3113.1
    ## <none>                          210744 3113.9
    ## - age_range         3    3695.4 214439 3116.6
    ## - matches           1    5241.5 215985 3124.2
    ## - position:goals    9   13767.7 224511 3127.5
    ## 
    ## Step:  AIC=3104.55
    ## market_value ~ position + age + matches + goals + own_goals + 
    ##     assists + yellow_cards + red_cards + substituted_on + substituted_off + 
    ##     age_range + position:goals
    ## 
    ##                   Df Sum of Sq    RSS    AIC
    ## - age              1      29.4 215311 3102.6
    ## - own_goals        1      93.9 215376 3102.8
    ## - yellow_cards     1     130.9 215413 3102.8
    ## - substituted_off  1     290.5 215572 3103.2
    ## - red_cards        1     292.8 215574 3103.2
    ## - substituted_on   1     429.4 215711 3103.5
    ## <none>                         215282 3104.6
    ## - assists          1     980.5 216262 3104.8
    ## - age_range        3    3776.3 219058 3107.2
    ## - matches          1    5634.8 220916 3115.5
    ## - position:goals  11   19415.8 234697 3125.7
    ## 
    ## Step:  AIC=3102.62
    ## market_value ~ position + matches + goals + own_goals + assists + 
    ##     yellow_cards + red_cards + substituted_on + substituted_off + 
    ##     age_range + position:goals
    ## 
    ##                   Df Sum of Sq    RSS    AIC
    ## - own_goals        1      93.6 215405 3100.8
    ## - yellow_cards     1     130.0 215441 3100.9
    ## - substituted_off  1     291.5 215603 3101.3
    ## - red_cards        1     293.9 215605 3101.3
    ## - substituted_on   1     454.5 215766 3101.7
    ## <none>                         215311 3102.6
    ## - assists          1     991.9 216303 3102.9
    ## - age_range        3    5263.2 220574 3108.7
    ## - matches          1    5608.1 220919 3113.5
    ## - position:goals  11   19390.3 234701 3123.7
    ## 
    ## Step:  AIC=3100.83
    ## market_value ~ position + matches + goals + assists + yellow_cards + 
    ##     red_cards + substituted_on + substituted_off + age_range + 
    ##     position:goals
    ## 
    ##                   Df Sum of Sq    RSS    AIC
    ## - yellow_cards     1     137.4 215542 3099.2
    ## - substituted_off  1     275.6 215680 3099.5
    ## - red_cards        1     310.6 215715 3099.6
    ## - substituted_on   1     431.9 215837 3099.8
    ## <none>                         215405 3100.8
    ## - assists          1     988.3 216393 3101.1
    ## - age_range        3    5492.9 220898 3107.4
    ## - matches          1    5533.0 220938 3111.5
    ## - position:goals  11   19374.4 234779 3121.9
    ## 
    ## Step:  AIC=3099.15
    ## market_value ~ position + matches + goals + assists + red_cards + 
    ##     substituted_on + substituted_off + age_range + position:goals
    ## 
    ##                   Df Sum of Sq    RSS    AIC
    ## - substituted_off  1     255.6 215798 3097.7
    ## - red_cards        1     302.0 215844 3097.8
    ## - substituted_on   1     348.0 215890 3098.0
    ## <none>                         215542 3099.2
    ## - assists          1    1046.1 216588 3099.6
    ## - age_range        3    5402.1 220944 3105.5
    ## - matches          1    5707.7 221250 3110.2
    ## - position:goals  11   19365.7 234908 3120.2
    ## 
    ## Step:  AIC=3097.74
    ## market_value ~ position + matches + goals + assists + red_cards + 
    ##     substituted_on + age_range + position:goals
    ## 
    ##                  Df Sum of Sq    RSS    AIC
    ## - substituted_on  1     361.4 216159 3096.6
    ## - red_cards       1     372.3 216170 3096.6
    ## <none>                        215798 3097.7
    ## - assists         1    1040.3 216838 3098.2
    ## - age_range       3    5249.7 221047 3103.8
    ## - matches         1    5567.2 221365 3108.5
    ## - position:goals 11   19840.3 235638 3119.7
    ## 
    ## Step:  AIC=3096.58
    ## market_value ~ position + matches + goals + assists + red_cards + 
    ##     age_range + position:goals
    ## 
    ##                  Df Sum of Sq    RSS    AIC
    ## - red_cards       1     373.9 216533 3095.4
    ## <none>                        216159 3096.6
    ## - assists         1    1065.0 217224 3097.0
    ## - age_range       3    5904.0 222063 3104.1
    ## - matches         1    5208.4 221367 3106.5
    ## - position:goals 11   20107.9 236267 3119.1
    ## 
    ## Step:  AIC=3095.44
    ## market_value ~ position + matches + goals + assists + age_range + 
    ##     position:goals
    ## 
    ##                  Df Sum of Sq    RSS    AIC
    ## <none>                        216533 3095.4
    ## - assists         1    1044.1 217577 3095.8
    ## - age_range       3    5761.0 222294 3102.6
    ## - matches         1    5228.0 221761 3105.4
    ## - position:goals 11   20559.9 237093 3118.8

    ## # A tibble: 30 x 5
    ##    term                       estimate std.error statistic  p.value
    ##    <chr>                         <dbl>     <dbl>     <dbl>    <dbl>
    ##  1 (Intercept)                   23.4       6.78     3.45  0.000614
    ##  2 positionCentral Midfield     -11.3       6.08    -1.85  0.0646  
    ##  3 positionCentre-Back          -10.1       5.80    -1.73  0.0834  
    ##  4 positionCentre-Forward       -23.8       6.99    -3.41  0.000714
    ##  5 positionDefensive Midfield    -7.17      6.85    -1.05  0.296   
    ##  6 positionGoalkeeper            -4.90      7.07    -0.693 0.489   
    ##  7 positionLeft Midfield        -23.0      22.2     -1.04  0.301   
    ##  8 positionLeft Winger          -20.9       6.75    -3.10  0.00205 
    ##  9 positionLeft-Back            -15.3       7.61    -2.02  0.0444  
    ## 10 positionRight Midfield        12.2      22.1      0.554 0.580   
    ## # ... with 20 more rows

    ## [1] 4534.834

    ## [1] 4516.383

    ## [1] 0.3189235

    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading
    
    ## Warning in predict.lm(model, data): prediction from a rank-deficient fit
    ## may be misleading

    ##        1        2        3        4        5        6        7        8 
    ## 17.10856 22.54012 16.10386 23.20919 24.56782 25.97028 20.62301 16.41933 
    ##        9       10 
    ## 21.94910 16.64924

Your project goes here\! Before you submit, make sure your chunks are
turned off with `echo = FALSE`.

You can add sections as you see fit. Make sure you have a section called
Introduction at the beginning and a section called Conclusion at the
end. The rest is up to you\!
