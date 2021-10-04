#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

execute <- function(plan, resource_pool, time_tracker_list){
p_list <- list(
  plan %>% form() %>% order_plan() %>% update_status(),
  resource_pool
)

result <- append(list(p_list), time_tracker_list) %>% accumulate(cycle_period)

comined <- 
map2(
  result %>% map(c(1)) %>% .[-1] %>% map(~ .x %>% mutate(one = 1)),
  map(time_tracker_list,as_tibble) %>% map(~ .x %>% mutate(one = 1)), 
  ~ left_join(.x,.y))

comined
}
