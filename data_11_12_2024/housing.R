##---- Packages
library(tidymodels)
library(tidyverse)
library(gt)
library(stringr)
library(visdat)
library(GGally)

####---- Import Data
link <- "https://raw.githubusercontent.com/kirenz/datasets/master/housing_unclean.csv"
hdf <- read_csv(link) #readr
dim(hdf)
colnames(hdf)
View(hdf)
head(hdf) |>
  gt()


#### ---- format

hdf |> 
  slice_head(n=6) |>
  gt()

#### ---- preprocessing
hdf <- 
  hdf |>
  mutate(
    housing_median_age=str_remove_all(housing_median_age, "[years]"),
    median_house_value = str_remove_all(median_house_value, "[$]"))
View(hdf)

#### ---- recheck the format
glimpse(hdf) 

#### ---- visualize the structure
vis_dat(hdf)

#### Observe summary statistics
hdf |>
  count(ocean_proximity, sort=TRUE)

#### Convert qualitative variables into factor
hdf <- hdf |>
  mutate(across(where(is.character), as.factor))
vis_dat(hdf)

## Convert variables into numeric
hdf <- hdf |>
  mutate(
    housing_median_age = as.numeric(housing_median_age),
    median_house_value = as.numeric(median_house_value)
  )
vis_dat(hdf)

### Observe missing value
vis_miss(hdf, sort_miss=TRUE)
is.na(hdf) |> colSums()

## Create new variables
hdf <- hdf |>
  mutate(rooms_per_household = total_rooms/households,
         bedrooms_per_room = total_bedrooms/total_rooms,
         population_per_household = population/households)

View(hdf)
## Dependent variable qualitative
hdf <- hdf |>
  mutate(price_category = case_when(
    median_house_value < 1500 ~ "below",
    median_house_value >= 1500 ~ "above",
  )) |>
  mutate(price_category = as.factor(price_category)) |>
  select(-median_house_value)
View(hdf)

# Distribution of the dependent variable
hdf |>
  count(price_category, name="count") |>
  mutate(percent = count/sum(count)) |>
  gt()


## Check the structure again
skimr::skim(hdf)

## EDA
hdf |>
  select(housing_median_age,
         median_income,
         bedrooms_per_room,
         rooms_per_household,
         population_per_household) |>
  ggscatmat(alpha=0.2)

# Your turn: hex binning scatterplot 

#Your turn: Obtain plot matrix using ggpairs

## 
hdf |>
  ggplot(aes(price_category)) + geom_bar()

## Split data into training and test
hdf_no_na <- hdf |> 
  drop_na()

set.seed(123)
data.split <- initial_split(hdf_no_na,
                            prop=3/4,
                            strata = price_category)
train.data <- training(data.split)
test.data <- testing(data.split)


library(randomForest)
rf <- randomForest(price_category ~ .,
                   data=train.data, 
                   importance=TRUE)
test.data$predict <- predict(rf, test.data)

View(test.data)

library(caret)
confusionMatrix(data = test.data$predict,
                reference = test.data$price_category)
