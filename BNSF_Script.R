#Retrieve Data File 
bnsf_file <- read.csv("C:/ArcGIS/Data/bnsf_warnings_with_duration/bnsf_wind_warnings_2015-2019.csv", header=FALSE)

#Rename Columns 
library(data.table)
setnames(bnsf_file, old=c("V1","V2","V3","V4","V5","V6","V7","V8","V9"), new=c("Start_Date","End_Date","Duration","Wind_Type","Wind_Speed","Subdivision","Milepost","Latitude","Longitude"))

#Recode Negative Values in Reporting Numeric Fields; Duration
bnsf_file$Duration <- abs(bnsf_file$Duration)

#Recode Human Error Reporting in Numeric Fields; Wind_Speed
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==550] <- 55
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==555] <- 55
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==565] <- 65
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==600] <- 60
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==602] <- 60
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==605] <- 60
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==630] <- 63
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==650] <- 65
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==655] <- 65
bnsf_file$Wind_Speed[bnsf_file$Wind_Speed==700] <- 70

View(bnsf_file)