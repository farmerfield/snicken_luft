

node_data %>% as_tibble() %>% 
  filter(node == "node-2", metric == "pms_pm2_5") %>% 
  ggplot(aes(x = time, y = value)) +
  geom_line() +
  scale_x_time(date_breaks = "3 hours", date_minor_breaks="sec", labels=date_format("%H:%M")) +
  #geom_smooth(method=lm , color="red", se=FALSE) +
  theme(legend.position="none")



# Source - https://stackoverflow.com/a/54020170
# Posted by DS_UNI, modified by community. See post 'Timeline' for change history
# Retrieved 2026-03-01, License - CC BY-SA 4.0

# library(scales)
# time_distance$time <- as.POSIXct(time_distance$time, format = "%H:%M:%S")
# 
# ggplot(time_distance, aes(x=time, y=distance, group=1)) + 
#   geom_point() +
#   geom_smooth(method=lm , color="red", se=FALSE) +theme(legend.position="none") + 
#   theme_bw()+
#   labs(y = "Distance [m]", x = "time [hour]")+
#   scale_y_continuous(limits=c(0,1600), breaks=seq(100, 1500, 100)) +
#   scale_x_datetime(date_breaks="1 hour", labels=date_format("%H:%M"))



# rolling <- daily_counts %>% 
#   mutate(                                # create new columns
#     # Using slide_dbl()
#     ###################
#     reg_7day = slide_dbl(
#       new_cases,                         # calculate on new_cases
#       .f = ~sum(.x, na.rm = T),          # function is sum() with missing values removed
#       .before = 6),                      # window is the ROW and 6 prior ROWS
#     
#     # Using slide_index_dbl()
#     #########################
#     indexed_7day = slide_index_dbl(
#       new_cases,                       # calculate on new_cases
#       .i = date_hospitalisation,       # indexed with date_onset 
#       .f = ~sum(.x, na.rm = TRUE),     # function is sum() with missing values removed
#       .before = days(6))               # window is the DAY and 6 prior DAYS
#   )



node_data %>% as_tibble() %>% 
  arrange(time) %>% 
  filter(node == "node-2", topic == "sensors_pms5003_node-2_sensor_pms_pm2_5_state") %>% 
  mutate(                                
     ma_60min = slide_dbl(
      value,                    
      .f = ~mean(.x, na.rm = T),         
      .before = 60)) %>% 
  ggplot(aes(x = time, y = ma_60min)) +
  geom_line() +
  scale_x_time(date_breaks = "2 hours", date_minor_breaks="hours", labels=date_format("%H:%M")) +
  theme_bw()
  
node_data %>% 
  as_tibble() %>% 
  filter(node == "node-2", topic == "sensors_pms5003_node-2_sensor_pms_pm2_5_state") %>% 
  mutate(
 ma_workday = slide_dbl(
    value,
    .f = ~mean(.x, na.rm = T),
    .before = 480
  ) 
) %>% 
  ggplot(aes(x = time, y = ma_workday)) +
  geom_line() +
  scale_x_time(date_breaks = "2 hours", date_minor_breaks="hours", labels=date_format("%H:%M")) +
  geom_hline(yintercept = 2, colour = "red")+
  theme_light()

    
    
