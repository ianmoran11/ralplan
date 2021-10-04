rm(list = ls())
library(devtools) 
install()
library(devtools)
library(lubridate)
library(ralget)
library(tidyverse)
library(tidygraph)
library(ralplan)
load_all()

Ta <- T(name = "a", time = duration("6 hours"), priority = 10, resources = list(ian   = 1))
Tb <- T(name = "b", time = duration("4 hours"), priority = 10, resources = list(john  = 1))
Tc <- T(name = "c", time = duration("3 hours"), priority = 4 , resources = list(ian  = 1))
Td <- T(name = "d", time = duration("1 hours"), priority = 1 , resources = list(geoff = 1))
Te <- T(name = "e", time = duration("1 hours"), priority = 2 , resources = list(geoff = 1))

plan <- Ta(once(Tb), once(Tc)) + Tb(after(Td)) + Tc(after(Td),after(Te)) 

result <- 
  execute( 
    plan, 
    resource_pool = list(cook = 1),
    time_tracker_list = create_work_times(n = 60,1),
  )


comined <- 
map2(
  result %>% map(c(1)) %>% .[-1] %>% map(~ .x %>% mutate(one = 1)),
  map(time_tracker_list,as_tibble) %>% map(~ .x %>% mutate(one = 1)), 
  ~ left_join(.x,.y))

bind_rows(map(comined,as_tibble)) %>%
  unnest(time) %>%
  ggplot(aes(x = start_time, y = time, color = name, group = name)) + geom_line()

bind_rows(map(comined,as_tibble)) %>%
  unnest(time) %>%
  group_by(name) %>%
  mutate(time_diff = -(time - lag(time,n = 1,order_by = start_time) )) %>%
  filter(!is.na(time_diff)) %>%
  ggplot(aes(x = start_time, y = name, fill = time_diff)) + 
  geom_tile(color = "white") +
  scale_fill_gradient(low = "white", high = "black")


library(microbenchmark)

microbenchmark(append(list(p_list), time_tracker_list) %>% accumulate(cycle_period), times = 1)
