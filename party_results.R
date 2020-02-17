# 2: Party Results in Regions ####
# https://www.cvk.gov.ua/pls/vnd2019/wp310pt001f01=919.html

get_regions <- function(){
  
  districts <- c(5,7, 12, 14,18,21,23,26,32,35,44,46,48,51,53,56,59, 61,63,65,68,71,73,74,80)  # Manually checked and written
                                                                                               # Can be improved
  for(i in districts) {
    
    url <- paste0("https://www.cvk.gov.ua/pls/vnd2019/wp317pt001f01=919pid100=", i ,".html")
    
    page <- html_session(url)
    
    table <- page %>% 
      html_table(fill = TRUE)
    
    table <- table[[2]]
    
    # Districts 
    
    font <- page %>% 
      html_node('.cntr.w100') %>% 
      html_text()
    
    table$font <- font
    
    # Counted % 
    
    perc <- page %>% 
      html_node('tr+ tr .b') %>% 
      html_text()
    
    table$perc <- perc
    
    # Region
    
    region <- page %>% 
      html_node('.pdd15b') %>% 
      html_text()
    
    table$region <- region
      
    #
    message(paste(font, 'завантажено'))
    
    write.table(table, 'party_results_in_regions.csv', 
                append = TRUE, 
                col.names = FALSE, 
                row.names = FALSE, 
                sep = ';')
    
    Sys.sleep(0.5)
    
  }
}

# Функція завантаження ####
party_results_in_regions <- get_regions()

