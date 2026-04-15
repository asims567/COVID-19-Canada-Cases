library(tidyverse)
library(lubridate)
library(car)
library(rstatix)

df_raw <- read_csv("covid19-download.csv")

df <- df_raw %>% 
  mutate(date = as.Date(date)) %>% 
  filter(prname != "Canada",
         prname != "Repatriated travellers") 

df_canada <- df_raw %>% 
  mutate(date = as.Date(date)) %>% 
  filter(prname == "Canada") 


class(df_canada$numdeaths)
class(df_canada$totalcases)
glimpse(df_canada)


str(df_cfr$totalcases)
str(df_cfr$numdeaths)


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


df_cfr %>%
  group_by(period) %>%
  summarise(mean_CFR = mean(CFR, na.rm = TRUE))

cat("T-test p-value:", t_result$p.value, "\n")


df_cfr <- df_cfr %>% 
  mutate(
    week = as.numeric(date - min(date)) / 7
  )

lm_model <- lm(CFR ~ week, data = df_cfr)
summary(lm_model)

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


