# ############################################# #
# Walk Detection using Activity Count           #
#                                               #
# This script runs walkTime on the baseline     #
# files for our LIFE dataset.                   #
#                                               #
# _____________________________________________ #
# Author: Matin Kheirkhahan                     #
#         matinkheirkhahan@ufl.edu              #
# ############################################# #

# The address where the scripts and functions are located.
working.directory <- "~/Workspaces/R workspace/Walk Detection using Activity Count/walk-detection-activity-count/"
visit <- 0 # {0, 6, 12, 24}

# Setting Criteria --------------------------------
NON_ZERO_THRESHOLD <- 70 # percent of non-zero points
SLIDING_STEP <- 30 # sliding window step in seconds
WINDOW_SIZE <- 30 # window length in seconds
EXPAND_SIZE <- 5 # expand the length upon walk detection, in seconds

# The Script ------------- main -------------------------------
setwd(working.directory)
source("f01_functions.R")

setwd("~/../../Volumes/SHARE/ARRC/Active_Studies/ANALYSIS_ONGOING/LIFE Main data/LIFE accelerometry - second data - 10_26_15/")
load("PID_VC_HID.Rdata")
PID_HID <- REF[REF$seq == 0, ]

result <- data.frame(matrix(nrow = 0, ncol = 8))
for(i in 1:(nrow(PID_HID))) {
     
     print(paste("          ", i, "out of", nrow(PID_HID)))
     PID <- PID_HID$pid[i]
     filename <- paste("HID", PID_HID$HID[i], ".Rdata", sep = "")
     if(file.exists(filename)) {
          load(filename)
          participant.result <- walkTime(ID = PID, ts = as.character(AC.1s$TimeStamp), axis_ = AC.1s$axis1, window.size = WINDOW_SIZE, expand.size = EXPAND_SIZE, slide.step = SLIDING_STEP, nonZeroThreshold = NON_ZERO_THRESHOLD)
          result <- rbind(result, participant.result)
     } else {
          print("Did not exist.")
     }
}


write.csv(result, file = "~/Workspaces/R workspace/Walk Detection using Activity Count/baseline_walks_020617.csv", row.names = F)