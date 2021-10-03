rm(list = ls())
library(devtools)
library(lubridate)
install("../ralget/")
library(ralget)
library(tidyverse)
library(tidygraph)
load_all()

Ta <- T(name = "a", time = duration("6 hours"), priority = 10, resources = list(ian   = 1))
Tb <- T(name = "b", time = duration("6 hours"), priority = 10, resources = list(john  = 1))
Tc <- T(name = "c", time = duration("6 hours"), priority = 4 , resources = list(john  = 1))
Td <- T(name = "d", time = duration("1 hours"), priority = 1 , resources = list(geoff = 1))
Te <- T(name = "e", time = duration("1 hours"), priority = 2 , resources = list(geoff = 1))

plan <- Ta(once(Tb), once(Tc)) + Tb(after(Td)) + Tc(after(Td),after(Te)) 

formed_plan <- form(plan)
plot(formed_plan)

# order tasks extract .attrs -----------------------------------------
formed_plan_01 <- order_plan(formed_plan)
resource_pool <- list(ian = 1, john = 1, geoff = 1)

time_tracker <- list(
    start_time = lubridate::ymd_hm("2021-10-03-9-00"), 
    interval = duration("~ 30 minutes"))


formed_plan_02 <- update_status(formed_plan_01)
# Identify potential tasks-------------------------------------------------------------- 
formed_plan_03 <- formed_plan_02 %>% filter(!outstanding_deps) %>% arrange(desc(priority))

plan_resource <- list(formed_plan_03, resource_pool,time_tracker)
round <- append(list(plan_resource), pull(formed_plan_03,name)) %>% reduce(try_task) 

updated_plan_tbl <- 
formed_plan_02 %>% 
    as_tibble() %>% 
    filter(!name %in% pull(round[[1]],name)) %>%
    bind_rows(as_tibble(round[[1]]))

p <- formed_plan_02 %>% select(name) %>% left_join(updated_plan_tbl)
#--------------------------------------------------------------------------
plan <- p
p_list <-  list(plan,resource_pool,time_tracker)

p_list %>%
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() %>% 
 cycle_period() 


# exectue tasks and update resources







