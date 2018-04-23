points <- read.table("pts2.txt")
kmeansCentroids <- read.csv("KmeansCentroids.txt", sep=" ", header=FALSE, na.strings="nan")[1:8]
kppCentroids <- read.csv("KppCentroids.txt", sep=" ", header=FALSE, na.strings="nan")[1:8]

plot(points, col=rgb(0,0,0,0.5))
for(i in 1:4) {
  points(x=kmeansCentroids[,1*i], y=kmeansCentroids[,2*i], pch=21, col=i+1, bg=rgb(0.1,0.1,0.1,0.1))
}

plot(points, col=rgb(0,0,0,0.5))
for(i in 1:4) {
  points(x=kppCentroids[,1*i], y=kppCentroids[,2*i], pch=25, col=i+1, bg=rgb(0.1,0.1,0.1,0.1))
}