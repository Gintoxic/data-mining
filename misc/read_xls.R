library(gdata)
pf<-"C:/Tools/strawberry/perl/bin/perl.exe"

installXLSXsupport(perl=pf)

test<-read.xls(xls="D:/Work/data/excel_test.xls", perl=pf)

str(test)