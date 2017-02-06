# Functions ----------------------------------------

# Used for my debugs
convertToFileName <- function(hid) {
     s <- as.character(hid)
     while(nchar(s) < 4) {
          s <- paste("0", s, sep = '')
     }
     paste("HID", s, ".Rdata", sep = '')
}

# Receives a time hh:mm:ss and returns and integer representing
#     which.part == 1: hh
#     which.part == 2: mm
#     which.part == 3: ss
just.onePartOfTime <- function(ts, which.part = 1) {
     times <- unlist(strsplit(ts, split = " "))[2]
     as.character(unlist(strsplit(times, split = ":"))[which.part])
}

# This function detects whether the selected window meets 'walk' criteria
isItWalk <- function(selected.chunk, nonZeroThreshold = 70) {
     selected.chunk <- selected.chunk[order(selected.chunk, decreasing = F)]
     discard.idx <- round(length(selected.chunk) * 0.9)
     selected.chunk <- selected.chunk[0:discard.idx]
     nonZeroPrc <- sum(selected.chunk > 0) / length(selected.chunk) * 100
     result <- FALSE
     if(nonZeroPrc >= nonZeroThreshold){
          result <- TRUE
     }
     result
}


walkTime <- function(ID, ts, axis_, window.size = 30, expand.size = 5, slide.step = 10, nonZeroThreshold = 70) {
     result <- data.frame(matrix(ncol = 8, nrow = 0))
     sec <- 1
     totalLength <- length(axis_)
     print(paste("Examining ", ID, " ... ", sep = ""))
     pb <- txtProgressBar(min = sec, max = totalLength, style = 3, initial = sec)
     while(sec < length(axis_)) {
          lastSec <- min(totalLength, (sec + window.size - 1))
          selected.chunk <- axis_[sec:lastSec]
          walk.flag <- isItWalk(selected.chunk, nonZeroThreshold)
          if(walk.flag) {
               while(walk.flag) {
                    lastSec <- lastSec + expand.size
                    selected.chunk <- axis_[sec:lastSec]
                    walk.flag <- isItWalk(selected.chunk, nonZeroThreshold)
               }
               lastSec <- lastSec - expand.size
               lastSec <- sec + max(which(axis_[sec:lastSec] > 0)) - 1
               curResult <- data.frame(ID, start.ts = ts[sec], end.ts = ts[lastSec], start.idx = sec, end.idx = lastSec, duration.sec = lastSec - sec,
                                       axis_activity_count_avg = mean(axis_[sec:lastSec]), axis_activity_count_std = sd(axis_[sec:lastSec]))
               result <- rbind(result, curResult)
               sec <- lastSec + slide.step
          } else {
               sec <- sec + slide.step
          }
          setTxtProgressBar(pb, value = sec)
     }
     result
}