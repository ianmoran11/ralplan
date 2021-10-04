#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export
 
plot_executed_plan <- function(comined){

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

}