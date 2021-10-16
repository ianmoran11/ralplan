
library(devtools)
library(lubridate)
library(ralget)
library(tidyverse)
library(tidygraph)
library(ralplan)
install.packages("hrbrthemes")
load_all()

reverse_min <- function(x){-min(as.numeric(x))}

put_on_wash1 <- T(name = "put_on_washe", time = duration("10 minutes"), priority = 10, resources = list(washing_machine = 1))
put_on_wash2 <- T(name = "put_on_washee", time = duration("10 minutes"), priority = 10, resources = list(washing_machine = 1))
wash1        <- T(name = "wash1", time = duration("120 minutes"), priority = 10, resources = list(washing_machine = 1))
wash2        <- T(name = "wash2", time = duration("120 minutes"), priority = 10, resources = list(washing_machine = 1))
hang_clothes <- T(name = "hang_clothes", time = duration("15 minutes"), priority = 10, resources = list(cook = 1))
fold_clothes <- T(name = "fold_clothes", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
iron         <- T(name = "iron", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
grocery_shop <- T(name = "grocery_shop", time = duration("15 minutes"), priority = 10, resources = list(cook = 1))
sweep_floors <- T(name = "Sweep floors", time = duration("20 minutes"), priority = 10, resources = list(cook = 1))
mop          <- T(name = "Mop", time = duration("20 minutes"), priority = 10, resources = list(cook = 1))
vacuum       <- T(name = "vacuum", time = duration("30 minutes"), priority = 10, resources = list(cook = 1))
dry_clothes  <- T(name = "dry_clothes", time = duration("6 hours"), priority = 10, resources = list(rack = 1))
dry_clothes_dryer  <- T(name = "dry_clothes_dryer", time = duration("2 hours"), priority = 10, resources = list(dryer = 1))



plan <- 
fold_clothes(after(dry_clothes_dryer)) + 
iron(after(dry_clothes)) + 
dry_clothes(after(hang_clothes)) + 
hang_clothes(after(wash2)) +
dry_clothes_dryer(after(wash2)) +
wash2(after(put_on_wash2)) + 
put_on_wash2(after(wash1)) +
wash1(after(put_on_wash1)) + 
vacuum(after(mop)) +
mop(after(sweep_floors))


plot(form(plan))

result <- 
  execute( 
    plan, 
    resource_pool = list(cook = 1, washing_machine = 1, dryer = 1, rack =1),
    timeslots = create_work_times(n = 4*24,15)
  )



p <- plot_executed_plan(result)
p

comined <- result
p$data %>% mutate(resources = map(resources,~ names(.x) %>% as_tibble() %>% 
  spread(value,1))) %>% unnest(resources) %>% 
  ggplot(aes(x = start_time, y = name, color = cook )) + geom_point()
result %>% map(1) %>% map(as_tibble) %>% bind_rows

result %>%
    ggplot(aes(x = start_time, y = name, fill = time_diff>0)) + 
    geom_line(color = "blue", size = 5,alpha = .75) +
    scale_fill_manual(values = c( "grey", "blue")) +
    guides(fill = "none") +
    labs(y = NULL, x = "Time")