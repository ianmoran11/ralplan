#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export
 
plot_executed_plan <- function(comined){
  insert_start_time <- comined[[2]][[1]] %>% pull(start_time) %>% .[[1]]
  
bind_rows(map(comined,1) %>% map(as_tibble)) %>%
  unnest(time) %>%
  mutate(start_time = ifelse(is.na(start_time), insert_start_time,start_time) %>% lubridate::as_datetime()) %>% 
  group_by(name) %>%
  mutate(time_diff = -(time - lag(time,n = 1,order_by = start_time) )) %>%
  filter(!is.na(time_diff) & time_diff != 0) %>%
  ungroup() %>%
  mutate(name = fct_reorder(name,start_time,.fun = reverse_min)) %>%
  ggplot(aes(x = start_time, y = name, fill = time_diff>0)) + 
  geom_point(color = "blue", size = 3) +
  geom_line(color = "blue", size = 2.5) +
  scale_fill_manual(values = c( "grey", "blue")) +
  guides(fill = "none") +
  labs(y = NULL, x = "Time") + 
  theme_minimal()
}