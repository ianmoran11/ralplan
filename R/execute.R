#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

execute <- function(plan, resource_pool, timeslots) {
  # browser()
  # Create list of plan and resources for accumulation
  p_list <- list(
    plan = plan %>% form() %>% order_plan() %>% update_status(),
    resources = resource_pool
  )

  # Convert from dataframe to list
  time_tracker_list <- 
  map2(timeslots$start_time, timeslots$interval, ~list(start_time = .x, interval = .y))
  
  # Accumulate over time slots
  result <- append(list(p_list), time_tracker_list) %>% accumulate(cycle_period)

  # Accumulate over time slots
  result
}
