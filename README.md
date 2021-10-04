
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ralplan

<!-- badges: start -->
<!-- badges: end -->

The goal of ralplan is to …

## Installation

You can install the released version of ralplan from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ralplan")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ianmoran11/ralplan")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(devtools)
library(lubridate)
library(ralget)
library(tidyverse)
library(tidygraph)
library(ralplan)

Ta <- T(name = "a", time = duration("6 hours"), priority = 10, resources = list(ian   = 1))
Tb <- T(name = "b", time = duration("4 hours"), priority = 10, resources = list(john  = 1))
Tc <- T(name = "c", time = duration("3 hours"), priority = 4 , resources = list(ian  = 1))
Td <- T(name = "d", time = duration("1 hours"), priority = 1 , resources = list(geoff = 1))
Te <- T(name = "e", time = duration("1 hours"), priority = 2 , resources = list(geoff = 1))

plan <- Ta(once(Tb), once(Tc)) + Tb(after(Td)) + Tc(after(Td),after(Te)) 

formed_plan <- form(plan)
plot(formed_plan)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
# order tasks extract .attrs -----------------------------------------
formed_plan_01 <- order_plan(formed_plan)
resource_pool <- list(ian = 1, john = 1, geoff = 1)
time_tracker_list <- create_work_times(80,15)

plan <- update_status(formed_plan_01)
# Identify potential tasks-------------------------------------------------------------- 
p_list <-  list(plan,resource_pool)

result <- append(list(p_list), time_tracker_list) %>% accumulate(cycle_period)

comined <- 
map2(
  result %>% map(c(1)) %>% .[-1] %>% map(~ .x %>% mutate(one = 1)),
  map(time_tracker_list,as_tibble) %>% map(~ .x %>% mutate(one = 1)), 
  ~ left_join(.x,.y))

bind_rows(map(comined,as_tibble)) %>%
  unnest(time) %>%
  ggplot(aes(x = start_time, y = time, color = name, group = name)) + geom_line()
```

<img src="man/figures/README-example-2.png" width="100%" />

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
bind_rows(map(comined,as_tibble)) %>%
  unnest(time) %>%
  group_by(name) %>%
  mutate(time_diff = -(time - lag(time,n = 1,order_by = start_time) )) %>%
  filter(!is.na(time_diff)) %>%
  ggplot(aes(x = start_time, y = name, fill = time_diff)) + 
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "black")
```

<img src="man/figures/README-cars-1.png" width="100%" />