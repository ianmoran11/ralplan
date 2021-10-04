
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

try_task <- function(plan_resource, task){
  # browser()
  plan <- plan_resource[[1]]
  resources <- plan_resource[[2]]
  time_tracker <- plan_resource[[3]]
  # task <- "e"
  
  used_resources <- plan %>% filter(name == task) %>% pull(resources) %>% .[[1]]
  
  new_resources <- 
  map2(names(used_resources), used_resources, function(.n,.r){
             resources[[.n]] <-resources[[.n]]  - .r
             resources
              }
             )
  
  result <- map_lgl(new_resources, ~ all(.x >=0))
  
  plan1 <- 
      plan %>% 
          mutate(time = pmap(list(name,time,task), function(name,time,task){
              time - ifelse((name == task) & result, time_tracker$interval,duration("0 min"))
          })) %>%
          mutate(executed = ifelse(time <= 0, TRUE,executed)) 
  
  pull(plan,time)
  pull(plan1,time)
  
  resources1 <- ifelse(result,new_resources, list(resources ))
  list(plan1, resources1[[1]], time_tracker)

}

