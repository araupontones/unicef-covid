
#' To scrap flags from the internet --------------------------------------------
#' @param url url of the site where the flags are scrapped from
#' @param iso iso code of the country of interest
#' @param exdir exit directory to store the flag
#' @result A .png file store in exdir
download_flag <- function(url = "https://www.worldometers.info/img/flags",
                          iso,
                          exdir ="imgs/flags"){
  
  message(iso)
  #url to the flag
  url_flag <- glue::glue("{url}/{iso}-flag.gif")
  #ex directory and file
  
  exfile <- glue::glue("{exdir}/{iso}.png")
  
  #get file 
  r <- GET(url_flag)
  
  #save file if status is OK
  if(r$status_code == 200){
    
    filecon <- file(exfile, "wb")
    #write data contents to download file
    writeBin(r$content, filecon)
    #close the connection
    close(filecon)
    cli::cli_alert_success("OK")
    
  } else {
    
    cli::cli_alert_warning("Doesn't exist")
  }
  
  
  
  
  
}




#' to clean name of countries or isos -----------------------------------------
#' @param old old name 
#' @param new new name
#' @param this variable to apply the function on

fix_name <- function(old, new, this = Country){
  
  if_else({{this}} == old, new, {{this}})
  
}
