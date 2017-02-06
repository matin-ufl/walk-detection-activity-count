# ############################################# #
# Walk Detection using Activity Count           #
#                                               #
# _____________________________________________ #
# Author: Matin Kheirkhahan                     #
#         matinkheirkhahan@ufl.edu              #
# ############################################# #


# The address where the scripts and functions are located.
working.directory <- "~/Workspaces/R workspace/Walk Detection using Activity Count/walk-detection-activity-count/"

# Setting Criteria --------------------------------
NON_ZERO_THRESHOLD <- 70 # percent of non-zero points
SLIDING_STEP <- 30 # sliding window step in seconds
WINDOW_SIZE <- 30 # window length in seconds
EXPAND_SIZE <- 5 # expand the length upon walk detection, in seconds

# The Script ------------- main -------------------------------
setwd(working.directory)
source("f01_functions.R")

# Loading data files (activity counts)
load("~/Desktop/Baseline/HID1007.Rdata")


# Data should have the following columns:
#   TimeStamp: a string representing date and time
#   axis1: activity count data per second for axis1
#   axis2: activity count data per second for axis2
#   axis3: activity count data per second for axis3

# All the necessary functions are provided in "f01_functions.R"
source("f01_functions.R")

# Running the walkTime() function on my dataframe (AC.1s)
rs <- walkTime(ID = "HID1007", ts = as.character(AC.1s$TimeStamp), axis_ = AC.1s$axis1, window.size = WINDOW_SIZE, expand.size = EXPAND_SIZE, slide.step = SLIDING_STEP, nonZeroThreshold = NON_ZERO_THRESHOLD)
