files<-dir("../Data/singles")





#text <- readLines(curfile,encoding="UTF-8")
#readLines(curfile,encoding="ANSI")

pmatch("#Vorname", text) # returns 2
strlist<-c("Anrede: ","#Vorname: ", "#Nachname: ", "#Strasse: ","#PLZ: ","#Ort: ","#Land: ", "#Tel: ","#Email: ","#Anspruch: ",
           "#Flugdatum: ", "#Flugnummer: ", "#Ticket-Nummer: ", "#Abflugort: ","#Planmäßiger_Zielort: ",
           "#Tatsächlicher_Ankunftsort: ",  "#Planmäßige_Abflugszeit: ","#Tatsächliche_Ankunftszeit: ", 
           "#Kontoinhaber: ","#IBAN: ", "#BIC: ")
enclist<-c("ANSI", "ANSI", "ANSI", "ANSI", "UTF-8", "ANSI","UTF-8")

mt<-matrix(nrow = 7,ncol = 21, data = "")

for (j in 1:length(files))
{
  curfile<-paste("../Data/singles/", files[j], sep="")
  text <- readLines(curfile,encoding=enclist[j])

  for (i in 1:length(strlist))
  {
    
    curstr<-strlist[i]
    curline<-pmatch(curstr, text)
    curval<-gsub(pattern = curstr,replacement = "", x = text[curline])
    print(curval)
    mt[j,i]<-curval
    
  }
  
}

cnames<-c("Anrede","Vorname", "Nachname", "Strasse","PLZ","Ort","Land", "Tel","Email","Anspruch",
           "Flugdatum", "Flugnummer", "Ticket_Nummer", "Abflugort","Plan_Zielort",
           "Tats_Ankunftsort",  "Plan_Abflugszeit","Tats_Ankunftszeit", 
           "Kontoinhaber","IBAN", "BIC")


fr<-as.data.frame(mt, stringsAsFactors = F)
colnames(fr)<-tolower(cnames)
fr$import_counter<-1:length(files)

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




con<-connectPg()
dbWriteTable(conn = con,name = "singles", value = fr)
disconnectPg(con)