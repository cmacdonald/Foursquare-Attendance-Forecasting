# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SMART FP7 - Search engine for MultimediA enviRonment generated contenT
# Webpage: http://smartfp7.eu
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# The Original Code is Copyright (c) 2012-2014 the University of Glasgow
# All Rights Reserved
#
# Contributor(s):
#  @author Romain Deveaud <romain.deveaud at glasgow.ac.uk>
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# This program is an example for a multi-threaded execution of the forecasts.
# It takes the name of the city as an argument in the command line.


library(tools,quietly=T,verbose=F)
library(parallel,quietly=T,verbose=F)
source("forecast_attendance.R")

get_files <- function(city) {
  folder <- paste(getFolder(), city, .Platform$file.sep, "attendances_crawl",sep="")
  print(paste("Scanning ", folder, " for ", city))
  # Gets all the time series files for a given city.
  ts_files <- list.files(folder,pattern="\\.ts$",full.names=T)
  return(ts_files)
}

save_forecast <- function(filein,dirout,city,nb_days_train) {
  if (! file.size(filein)) == 0)
  {
    forecast <- forecast_attendance(file=filein, city=city, nb_days_train=nb_days_train)
    venueid <- sub(".ts", "", basename(filein))
    venue_forecast_file <- paste(dirout,venueid, ".forecast",sep="")
    write.table(forecast, file=venue_forecast_file, row.names=FALSE,quote=FALSE,col.names=FALSE)
  }
}

args <- commandArgs()

city <- args[6]
print(paste("City is ",city, sep=""))


targetdir <- paste(getFolder(), city, "_forecasts", .Platform$file.sep, "live_arima", .Platform$file.sep,sep="")
dir.create(file.path(targetdir))
print(paste("Creating forecasts in ", targetdir, sep=""))


# args[6] is the name of the city given as argument.
files <- get_files(city)

print(length(files))

# Calling the `forecas_attendance` function for each element of the `files` array,
# with the city and the number of training as parameters.
# The number of required cores can be changed by using the `mc.cores` parameter.
mclapply(files,save_forecast, dirout=targetdir, city=city, nb_days_train=28, mc.cores=8, mc.silent=T)
