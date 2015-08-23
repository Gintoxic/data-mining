files<-dir("../Data/singles")

i=1

curfile<-paste("../Data/singles/", files[i], sep="")

#text <- readLines(curfile,encoding="UTF-8")
text <- readLines(curfile,encoding="ANSI")


pmatch("#Vorname", text) # returns 2

for (j=1:length(text))
{
  
  
  
  
}

# 
# p(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE,
#   fixed = FALSE, useBytes = FALSE, invert = FALSE)
# 
# grepl(pattern, x, ignore.case = FALSE, perl = FALSE,
#       fixed = FALSE, useBytes = FALSE)
# 
# sub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
#     fixed = FALSE, useBytes = FALSE)
# 
# gsub(pattern, replacement, x, ignore.case = FALSE, perl = FALSE,
#      fixed = FALSE, useBytes = FALSE)
# 
# regexpr(pattern, text, ignore.case = FALSE, perl = FALSE,
#         fixed = FALSE, useBytes = FALSE)
# 
# gregexpr(pattern, text, ignore.case = FALSE, perl = FALSE,
#          fixed = FALSE, useBytes = FALSE)
# 
# regexec(pattern, text, ignore.case = FALSE, perl = FALSE,
#         fixed = FALSE, useBytes = FALSE)