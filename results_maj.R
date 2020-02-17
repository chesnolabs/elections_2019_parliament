library(tidyr)
library(dplyr)
library(rvest)
library(xml2)

# Функція для завантажування результатів виборів з сайту Центральної виборчої комісії ####
# Get majoritarian districts results ####

get_data <- function(){
  districts <- c(11:40, 45:52, 57:60, 62:103, 105:107, 112:223) # Available and non-occupied districts in Ukraine in July 2019
  
  for(i in districts) {
    
    url <- paste0("https://www.cvk.gov.ua/pls/vnd2019/wp040pt001f01=919pf7331=", i ,".html")
    
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
    
    write.table(table, 'majoritarian_elections_results.csv', 
                append = TRUE, 
                col.names = FALSE, 
                row.names = FALSE, 
                sep = ';')
    
    Sys.sleep(1)
    
  }
}

# Запуск завантаження ####
major_mps <- get_data()

# Читати файл ####
majoritarian_elections <- read.csv2("majoritarian_elections_results.csv", header=FALSE)

# Чистимо таблицю ####
elections_res <- majoritarian_elections%>%
  mutate(V4=gsub(" ", "", majoritarian_elections$V4, fixed = TRUE))%>% # Get rid of white spaces
  mutate(V4=as.numeric(majoritarian_elections2$V4))
