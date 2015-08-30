getRateTo_EUR<-function(currencySource)
{
  library(RCurl)
  library(rjson)
  
  base_url<-"http://www.freecurrencyconverterapi.com/api/v2/convert?q=<SOURCE>_EUR&compact=y"
  requrl<-gsub("<SOURCE>", currencySource, base_url)
  r <- getURL(requrl)
  f <- fromJSON(r)
  u<-unlist(f)
  vec<-c(as.character(Sys.Date()),currencySource,u)
  names(vec)<-c("date", "currency", "rate")
  fr<-as.data.frame(t(vec))
  fr$rate<-as.numeric(as.character(fr$rate))
  return(fr)
}



connectPg=function()
{
  con <- dbConnect(postgres, "jdbc:postgresql://localhost:5432/flightrefund", user = "postgres", password = "postgres" )
  return(con)
}

disconnectPg=function(con)
{
  dbDisconnect(con)
}