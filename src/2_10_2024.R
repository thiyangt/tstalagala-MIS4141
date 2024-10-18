## pkg
library(tidyverse) 
library(denguedatahub)
library(skimr)
library(visdat)
library(naniar)
library(funModeling)

## dataset
srilanka_weekly_data
View(srilanka_weekly_data)
dim(srilanka_weekly_data) #23882     6
class(srilanka_weekly_data) ## tibble

world_annual
View(world_annual)
class(world_annual) #data.frame
dim(world_annual) #2773284      10

## data profiling
### Method 1
skim(srilanka_weekly_data)

### Method 2
status(srilanka_weekly_data)
data_integrity(srilanka_weekly_data)
profiling_num(srilanka_weekly_data)
plot_num(srilanka_weekly_data)
freq(srilanka_weekly_data)

### Method 3
library(dlookr)
diagnose(srilanka_weekly_data, 
         year, 
         week, 
         cases)

## data visualisations for data profiling
vis_dat(srilanka_weekly_data)

vis_dat(world_annual)

world_annual |>
  dplyr::slice(1:1000) |>
  vis_dat()


skim(world_annual)

## Section 2.5.1

data <- srilanka_weekly_data |>
  select(where(is.numeric))
View(data)

data <- data |>
  filter(year==2024)

srilanka_weekly_data |>
  select(where(is.numeric)) |>
  vis_value()


srilanka_weekly_data |>
  select(where(is.numeric)) |>
  arrange(cases) |>
  vis_value()


## Visualising binary data

## Sample dataset
df1 <- tibble(x=rep(c(1, 0), 50), 
              y=c(rep(1, 50), 
                  rep(0, 50)))

View(df1)
vis_binary(df1)


## Visualising messy datasets

set.seed(8)
x <- c("TRUE", "TRUE", 1, 200, 1L, 30,
       30.5, 1, 0, "2014/1/2")
y <- sample(x)
z <- sample(y)
df2 <- tibble(x, y, z)
df2
View(df2)

vis_guess(df2)


## Visualise missing data
vis_miss(srilanka_weekly_data)

world_annual |>
  slice(1:2000) |>
  vis_miss()


world_annual |>
  slice(1:2000) |>
  gg_miss_var()


world_annual |>
  slice(1:2000) |>
  gg_miss_var(facet = year)





## Relationships between 
## missing values

world_annual |>
  slice(1:2000) |>
  as_shadow_upset() |>
  UpSetR::upset()


## CRAN
devtools::install_github("thiyangt/drone")
library(drone)
data("worldbankdata")
worldbankdata
View(worldbankdata)

worldbankdata |>
  as_shadow_upset() |>
  UpSetR::upset()


