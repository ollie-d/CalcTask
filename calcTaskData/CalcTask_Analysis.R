rm(list = ls())
.rs.restartR()
# Install/load required libs
#install.packages("rjson")
#install.packages("stringr")
library("rjson")
library("stringr")

# Set data directory variables
DIR <- 'C:/Users/H8801/Desktop/calcTaskData/'
#sub_dirs <- c('ver0', 'ver1', 'ver2', 'ver3', 'ver4') # all data (<ver3 might be less good)
sub_dirs <- c('ver3', 'ver4') # main data

# Iterate through sub_dirs and grab participant SIDs
SIDs <- c()
for (sub in sub_dirs) {
  SIDs <- c(SIDs, substr(list.files(paste0(DIR, sub)), 0, 12))
}
SIDs <- unique(SIDs)

# Create nested named list with SID entries
df <- c()
for (sid in SIDs) {
  list_ = list(c())
  names(list_) = sid
  df <- c(df, list_)
}

# The goal is to have a dict (named list) with number of SID elements
# Each sid will have a sublist of baseline, main, survey
# Each of these sublists will contain the data in an accordingly nested list format
# We also want to keep track of the files everyone has in files_df
files_df <- as.data.frame(matrix(data=FALSE, nrow=length(SIDs), ncol=4))
colnames(files_df) <- c('SID', 'has_baseline', 'has_main', 'has_survey')
files_df$SID <- SIDs
bad_sids <- as.data.frame(matrix(data=NA, nrow=0, ncol=1))
for (sub in sub_dirs) {
  for (sid in SIDs) {
    files = list.files(paste0(DIR, sub), pattern=sid)
    for (file in files) {
      fname = paste0(DIR, sub, '/', file)
      data_ = fromJSON(file=fname)
      data_str = readChar(fname, file.info(fname)$size)
      if (grepl('baseline', file)) {
        df[[sid]][['baseline']] <- data_
        files_df[which(files_df$SID == sid), 'has_baseline'] = TRUE
      } else if (grepl('main', file)) {
        df[[sid]][['main']] <- data_
        files_df[which(files_df$SID == sid), 'has_main'] = TRUE
      } else if (grepl('survey', file)) {
        df[[sid]][['survey']] <- data_
        files_df[which(files_df$SID == sid), 'has_survey'] = TRUE
      }
      # Also check if they have debug code in their submission
      # so we cna drop them
      if (grepl('!time=2', data_str)) {
        bad_sids[[length(bad_sids)+1]] = sid
      }
    }
  }
}

# Only keep participants with baseline and main
good_sids <- files_df[which((files_df$has_main == TRUE) & (files_df$has_baseline == TRUE)),]$SID
good_data <- df[good_sids]

#---------------------------------------------------------------------------------------
# Let's create some helper functions to make our ridiculous upcoming loop more readable
#---------------------------------------------------------------------------------------

# Levels will be decoded using known attributes
# - Number of operators
# - Number of n-digit operands where n=1:3
LEVELS <- as.data.frame(matrix(data=NA, nrow=14, ncol=2))
colnames(LEVELS) <- c('key', 'level')
LEVELS$level <- 1:14

# We can represent this in a list with 4 values
# decoder = c(num_operators, num_n1, num_n2, num_n3)
# Using this, the levels translate as following
LEVELS[1,  'key'] <- "1200"
LEVELS[2,  'key'] <- "2300"
LEVELS[3,  'key'] <- "1110"
LEVELS[4,  'key'] <- "3400"
LEVELS[5,  'key'] <- "2210"
LEVELS[6,  'key'] <- "1020"
LEVELS[7,  'key'] <- "3310"
LEVELS[8,  'key'] <- "2120"
LEVELS[9,  'key'] <- "1011"
LEVELS[10, 'key'] <- "3040"
LEVELS[11, 'key'] <- "2021"
LEVELS[12, 'key'] <- "3031"
LEVELS[13, 'key'] <- "2003"
LEVELS[14, 'key'] <- "3004"

get_prob_lvl <- function(q) {
  # Determines the problem level
  # Requires the mean level of the block
  # Levels will be decoded using known attributes
  # stored in the LEVELS global variable
  
  # Count the number of ops, n1, n2, n3 in question
  ans_ = 'XXXX'
  nops = str_count(q, regex("\\+"))
  n3 = str_count(q, regex("[0123456789]{3}"))      
  n2 = str_count(q, regex("[0123456789]{2}")) - n3 
  n1 = nops + 1 - n3 - n2
  
  str_sub(ans_, 1, 1) = toString(nops) # num ops
  str_sub(ans_, 2, 2) = toString(n1)   # num n1
  str_sub(ans_, 3, 3) = toString(n2)   # num n2
  str_sub(ans_, 4, 4) = toString(n3)   # num n3
  return(LEVELS[which(LEVELS$key == ans_), 'level'])
}

is_prob_hard <- function(lvl, mean_level) {
  # If level is -2 or -1 mean, easy, else, hard
  if (mean_lvl - lvl > 0) { return(FALSE) }
  return(TRUE)
}

get_prob_dur <- function(q) {
  # Returns question duration
  return(q$answered_time - q$question_time_start)
}

# Now that we have our good data, let's extract the info we want.
# - SID (string)
# - Calc used (boolean)
# - Was problem hard (boolean true=hard)
# - Mean level (int)
# - Problem level (int)
# - Problem duration (int, ms time)
# - Problem correct (boolean, true=correct answer)
# - Calculator delay (int, constant per individual)

data_baseline <- as.data.frame(matrix(data=NA, nrow=0, ncol=8))
colnames(data_baseline) <- c('SID', 'used_calc', 'problem_hard', 'block_mean_level', 'problem_level', 'problem_duration', 'problem_correct', 'calc_delay')
data_main <- data.frame(data_baseline) # deep copy
#tracemem(data_baseline) == tracemem(data_main) # confirm deep copy

# Time to run some nested loops again
sets <- c('baseline', 'main')
for (set in sets) {
  for (sid in good_sids) {
    # Grab calc delay
    calc_delay = good_data[[sid]][[set]]$calc_equals_delay
    # Iterate over blocks
    num_blocks = length(good_data[[sid]][[set]]$block_data)
    for (b in 1:num_blocks) {
      # Grab mean level of block
      mean_lvl = good_data[[sid]][[set]]$block_data[[b]]$mean_level
      
      # Grab number of questions
      num_questions = length(good_data[[sid]][[set]]$block_data[[b]]$questions)
      for (q in 1:num_questions) {
        q_dur = as.numeric(get_prob_dur(good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]))
        if (length(q_dur) == 0L) { q_dur = NA }
        q_lvl = get_prob_lvl(good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]$question)
        q_dif = is_prob_hard(q_lvl, mean_lvl)
        q_cor = FALSE
        # Replace NULL with FALSE
        if (is.null(good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]$user_correct)) {
          good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]$user_correct = FALSE
        }
        
        if (good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]$user_correct == "True") {
          q_cor = TRUE
        }
        q_used_calc = FALSE
        if (length(good_data[[sid]][[set]]$block_data[[b]]$questions[[q]]$events) > 1) {
          q_used_calc = TRUE
        }
        # Now that we have all of our values, add them to our dataset
        data_ = c(sid, q_used_calc, q_dif, mean_lvl, q_lvl, q_dur, q_cor, calc_delay)
        if (set == 'baseline') {
          data_baseline[dim(data_baseline)[1]+1, ] <- data_
        } else if (set == 'main') {
          data_main[dim(data_main)[1]+1, ] <- data_
        }
      }
    }
  }
}

# Drop NAs (from problem duration)
data_baseline <- na.omit(data_baseline)
data_main     <- na.omit(data_main)

# Turn numeric
data_baseline$problem_duration <- as.numeric(data_baseline$problem_duration)
data_main$problem_duration <- as.numeric(data_main$problem_duration)

# Drop <100ms responses in problem duration (means instant click of submit)
data_baseline <- data_baseline[which(data_baseline$problem_duration > 100),]
data_main <- data_main[which(data_main$problem_duration > 100),]

# Export data
write.csv(data_baseline, 'data_baseline.csv')
write.csv(data_main, 'data_main.csv')

# See how many calc/non-calc we have
num_5_wcalc = dim(data_main[which((data_main$calc_delay == "5") & (data_main$used_calc == "TRUE")),])[1]    # 29
num_5_wocalc = dim(data_main[which((data_main$calc_delay == "5") & (data_main$used_calc == "FALSE")),])[1]  # 556
num_3_wcalc = dim(data_main[which((data_main$calc_delay == "3") & (data_main$used_calc == "TRUE")),])[1]    # 37
num_3_wocalc = dim(data_main[which((data_main$calc_delay == "3") & (data_main$used_calc == "FALSE")),])[1]  # 406

# Calculate user scores (main)
scores <- as.data.frame(matrix(data=NA, nrow=length(good_sids), ncol=2))
colnames(scores) <- c('SID', 'score')
scores$SID <- good_sids
for (sid in good_sids) {
  scores[which(scores$SID == sid), 'score'] = length(data_main[which((data_main$SID == sid) & (data_main$problem_correct == "TRUE")), 1])
}
scores$score <- as.numeric(scores$score)
max(scores$score)
