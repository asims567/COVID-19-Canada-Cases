library(tidyverse)
library(lubridate)
library(car)
library(rstatix)

df_raw <- read_csv("covid19-download.csv")

Rows: 3630 Columns: 23                     , eta:  0s
── Column specification ───────────────────
Delimiter: ","
chr  (10): prname, prnameFR, totalcases...
dbl  (12): pruid, reporting_week, repor...
date  (1): date


df <- df_raw %>% 
  mutate(date = as.Date(date)) %>% 
  filter(prname != "Canada",
         prname != "Repatriated travellers") 

df_canada <- df_raw %>% 
  mutate(date = as.Date(date)) %>% 
  filter(prname == "Canada") 


class(df_canada$numdeaths)
1] "numeric"

class(df_canada$totalcases)
[1] "character"

glimpse(df_canada)
Rows: 242
Columns: 23
$ pruid               <dbl> 1, 1, 1, 1, 1…
$ prname              <chr> "Canada", "Ca…
$ prnameFR            <chr> "Canada", "Ca…
$ date                <date> 2020-02-08, …
$ reporting_week      <dbl> 6, 7, 8, 9, 1…
$ reporting_year      <dbl> 2020, 2020, 2…
$ update              <dbl> NA, NA, NA, N…
$ totalcases          <chr> "8", "8", "11…
$ numtotal_last7      <chr> "4", "0", "3"…
$ ratecases_total     <chr> "0.02", "0.02…
$ numdeaths           <dbl> 0, 0, 0, 0, 0…
$ numdeaths_last7     <dbl> 0, 0, 0, 0, 0…
$ ratedeaths          <dbl> 0.00, 0.00, 0…
$ ratecases_last7     <chr> "0.01", "0", …
$ ratedeaths_last7    <dbl> 0.00, 0.00, 0…
$ numtotal_last14     <chr> "5", "4", "3"…
$ numdeaths_last14    <dbl> 0, 0, 0, 0, 0…
$ ratetotal_last14    <chr> "0.01", "0.01…
$ ratedeaths_last14   <dbl> 0.00, 0.00, 0…
$ avgcases_last7      <chr> "0.57", "0", …
$ avgincidence_last7  <chr> "0", "0", "0"…
$ avgdeaths_last7     <dbl> 0.00, 0.00, 0…
$ avgratedeaths_last7 <dbl> 0.00, 0.00, 0…

str(df_cfr$totalcases)
num [1:225] 8 8 11 25 63 ...

str(df_cfr$numdeaths)
num [1:225] 0 0 0 0 0 ..


library(readr)
df_cfr <- df_canada %>%
  mutate(
    totalcases = as.character(totalcases),
    numdeaths  = as.character(numdeaths)
  ) %>%
  filter(grepl("^[0-9,]+$", totalcases),
         grepl("^[0-9,]+$", numdeaths)) %>%
  mutate(
    totalcases = as.numeric(gsub(",", "", totalcases)),
    numdeaths  = as.numeric(gsub(",", "", numdeaths))
  ) %>%
  filter(totalcases > 0) %>%
  mutate(
    CFR = (numdeaths / totalcases) * 100
  )

library(ggplot2)
ggplot(df_cfr, aes(x = date, y = CFR)) +
  geom_line(color = "blue") +
  labs(
    title = "COVID-19 Case Fatality Rate (Canada)",
    x = "Date",
    y = "CFR (%)"
  ) +
  theme_minimal()


df_cfr <- df_cfr %>% 
  mutate(
    period = if_else(date < as.Date("2021-07-01"),
                     "Pre-Vaccine", "Post-Vaccine")
  )

t_result <- t.test(CFR ~ period, data = df_cfr)
print(t_result)

Welch Two-Sample t-test

data:  CFR by period
t = -8.9679, df = 72.422, p-value =
2.284e-13
Alternative hypothesis: true difference in means between group Post-Vaccine and group Pre-Vaccine is not equal to 0
95 percent confidence interval:
 -3.728463 -2.372439
sample estimates:
mean in group Post-Vaccine 
                  1.226145 
 mean in group Pre-Vaccine 
                  4.276596 

df_cfr %>%
  group_by(period) %>%
  summarise(mean_CFR = mean(CFR, na.rm = TRUE))

period       mean_CFR
  <chr>           <dbl>
1 Post-Vaccine     1.23
2 Pre-Vaccine      4.28


cat("T-test p-value:", t_result$p.value, "\n")
T-test p-value: 2.283581e-13 


df_cfr <- df_cfr %>% 
  mutate(
    week = as.numeric(date - min(date)) / 7
  )

lm_model <- lm(CFR ~ week, data = df_cfr)
summary(lm_model)

Call:
lm(formula = CFR ~ week, data = df_cfr)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.5073 -1.0459 -0.4295  0.6737  4.9869 

Coefficients:
             Estimate Std. Error t value
(Intercept)  4.507255   0.231322   19.48
week        -0.020459   0.001787  -11.45
            Pr(>|t|)    
(Intercept)   <2e-16 ***
week          <2e-16 ***
---
Signif. codes:  
  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’
  0.1 ‘ ’ 1

Residual standard error: 1.741 on 223 degrees of freedom
Multiple R-squared:  0.3703,	Adjusted R-squared:  0.3675 
F-statistic: 131.1 on 1 and 223 DF,  p-value: < 2.2e-16


library(ggplot2)
ggplot(df_cfr, aes(x = week, y = CFR)) +
  geom_point(alpha = 0.4) + 
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Trend In CFR Over Time",
    x = "Weeks Since Beginning", 
    y = "CFR (%)"
  ) + 
  theme_minimal()


cor_data <- cor_data[complete.cases(cor_data), ]

if (nrow(cor_data) > 0) {
  print("--- Correlation Result ---")
  print(cor.test(cor_data$cases, cor_data$deaths))


Pearson's product-moment
	correlation

data:  cor_data$cases and cor_data$deaths
t = 312.83, df = 3373,
p-value < 2.2e-16
Alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.9820374 0.9842881
sample estimates:
   cor 
0.9832 


on_qc <- subset(data, prname %in% c("Ontario", "Quebec")) 
on_qc_clean <- on_qc[!is.na(on_qc$numdeaths_last7), ]
on_qc_clean$prname <- factor(on_qc_clean$prname)


print("--- T-Test: Ontario vs Quebec ---")
t.test(numdeaths_last7 ~ prname, data = on_qc_clean)

Welch Two-Sample t-test

data:  numdeaths_last7 by prname
t = -0.69284, df = 450.06,
p-value = 0.4888
Alternative hypothesis: the true difference in means between group Ontario and group Quebec is not equal to 0
95 percent confidence interval:
 -26.63376  12.74946
sample estimates:
mean in the group Ontario 
             77.98760 
 mean in the group Quebec 
             84.92975

boxplot(numdeaths_last7 ~ prname, 
        data = on_qc_clean,
        main = "Weekly Deaths: Ontario vs Quebec", 
        col = c("blue", "red"), 
        ylab = "Deaths (Last 7 Days)", 
        xlab = "Province", 
        names = c("Ontario", "Quebec"),
        las = 1.5)
