library(devtools)
library(lubridate)
library(ralget)
library(tidyverse)
library(tidygraph)
library(ralplan)
load_all()

separate_egg <- T(name = "Separate egg", time = duration("5 minutes"), priority = 10, resources = list(cook = 1))
lemon_filling <- T(name = "Make lemon filling", time = duration("10 minutes"), priority = 10, resources = list(cook = 1))
make_meringue <- T(name = "Make meringue", time = duration("10 minutes"), priority = 10, resources = list(cook = 1))
crust <- T(name = "Fill crust", time = duration("5 minutes"), priority = 10, resources = list(cook = 1))
add_meringue <- T(name = "Add meringue", time = duration("5 minutes"), priority = 10, resources = list(cook = 1))

plan <- 
 add_meringue(after(make_meringue), after(crust)) +
 lemon_filling(after(separate_egg)) + 
 make_meringue(after(separate_egg)) + 
 crust(after(make_meringue)) 

plot(plan)
plot(form(plan))

formed_plan <- form(plan)


# order tasks extract .attrs -----------------------------------------
formed_plan_01 <- order_plan(formed_plan)
resource_pool <- list(cook = 1)
time_tracker_list <- create_work_times(n = 60,1)

plan <- update_status(formed_plan_01)
# Identify potential tasks-------------------------------------------------------------- 
p_list <-  list(plan,resource_pool)

result <- append(list(p_list), time_tracker_list) %>% accumulate(cycle_period)

comined <- 
map2(
  result %>% map(c(1)) %>% .[-1] %>% map(~ .x %>% mutate(one = 1)),
  map(time_tracker_list,as_tibble) %>% map(~ .x %>% mutate(one = 1)), 
  ~ left_join(.x,.y))

reverse_min <- function(x){-min(as.numeric(x))}

bind_rows(map(comined,as_tibble)) %>%
  unnest(time) %>%
  group_by(name) %>%
  mutate(time_diff = -(time - lag(time,n = 1,order_by = start_time) )) %>%
  filter(!is.na(time_diff) & time_diff != 0) %>%
  ungroup() %>%
  mutate(name = fct_reorder(name,start_time,.fun = reverse_min)) %>%
  ggplot(aes(x = start_time, y = name, fill = time_diff>0)) + 
  geom_tile(color = "white") +
  scale_fill_manual(values = "blue") +
  guides(fill = FALSE) +
  labs(y = NULL, x = "Time")

