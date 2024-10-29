library(DSjobtracker)
data("DSraw")
View(DSraw)


## skimr
library(skimr)
skim(DSraw)

write.csv(DSraw, file="DSraw.csv")

##
## select: variables
## filter: observations

library(dplyr)
# With missing
binary_vars1 <- DSraw |>
  select(where(~ n_distinct(.) == 2))
binary_vars1
vis_binary(binary_vars1)
unique(binary_vars1$Wordpress)


## Without missing
binary_vars2 <- DSraw |>
  select(where(~ n_distinct(., na.rm=TRUE) == 2))
binary_vars2
dim(binary_vars2)
vis_binary(binary_vars2)
## QUestion?

NA - missing
0 - not specified
1 - specified

?DSraw

## English proficiency (White spaces in clumn names)
unique(DSraw$`English proficiency`)
#
class(DSraw$DateRetrieved)
unique(DSraw$DateRetrieved)
#
unique(DSraw$Salary)
#
unique(DSraw$Job_title)
#
vis_guess(DSraw)
#
DSraw <- DSraw |>
  mutate(across(where(is.character), as.factor))
vis_guess(DSraw)

# Remove complete missing rows


