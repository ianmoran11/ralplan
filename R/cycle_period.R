#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

cycle_period <- function(p_list,time_tracker){

  # browser()
    plan          <- p_list[[1]]
    resource_pool <- p_list[[2]]
    # time_tracker  <- p_list[[3]]

    formed_plan_03 <- plan %>% update_status() %>% filter(!outstanding_deps & (executed == FALSE)) %>% arrange(desc(priority))

    plan_resource <- list(formed_plan_03, resource_pool,time_tracker)
    round <- append(list(plan_resource), pull(formed_plan_03,name)) %>% reduce(try_task) 

    updated_plan_tbl <- 
    plan %>% 
        as_tibble() %>% 
        filter(!name %in% pull(round[[1]],name)) %>%
        bind_rows(as_tibble(round[[1]]))

    p <- plan %>% select(name) %>% left_join(updated_plan_tbl)

    time_tracker$start_time <- time_tracker$start_time + time_tracker$interval
     
    p_list <-  list(p,resource_pool)

    p_list
}
# exectue tasks and update resources
