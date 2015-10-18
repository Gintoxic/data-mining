
library(RJDBC)

connectPg=function()
{
  postgres <- JDBC( "org.postgresql.Driver", "postgresql-9.3-1101.jdbc3.jar")
  con <- dbConnect(postgres, "jdbc:postgresql://localhost:5432/flightrefund", user = "postgres", 
                   password = "postgres" )
  return(con)
}

disconnectPg=function(con)
{
  dbDisconnect(con)
}
