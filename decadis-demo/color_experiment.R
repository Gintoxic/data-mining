

plot(deutschland)
deutschland$col="gray50"
plot(deutschland, col=deutschland$col)

ind<-which(deutschland$NAME_1=="Hessen")
deutschland$col[ind]<-"red"
plot(deutschland, col=deutschland$col)
jetColors(10)


rainbow_hcl(n, c = 50, l = 70, start = 0, end = 360*(n-1)/n,
            gamma = 2.4, fixup = TRUE, ...)

sequential_hcl(n, h = 260, c. = c(80, 0), l = c(30, 90), power = 1.5,
               gamma = 2.4, fixup = TRUE, ...)
heat_hcl(n, h = c(0, 90), c. = c(100, 30), l = c(50, 90), power = c(1/5, 1),
         gamma = 2.4, fixup = TRUE, ...)
terrain_hcl(n, h = c(130, 0), c. = c(80, 0), l = c(60, 95), power = c(1/10, 1),
            gamma = 2.4, fixup = TRUE, ...)

diverge_hcl(n, h = c(260, 0), c = 80, l = c(30, 90), power = 1.5,
            gamma = 2.4, fixup = TRUE, ...)
diverge_hsv(n, h = c(240, 0), s = 1, v = 1, power = 1,
            gamma = 2.4, fixup = TRUE, ...)


col<-terrain_hcl(12)
