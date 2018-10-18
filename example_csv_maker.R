# an example of taking the dataexamples.md file and making a csv using R
# by David Hood @thoughtfulnz on Twitter

library(dplyr)
# dplyr is a R helper library for structuring the processing of data
library(tidyr)
# tidyr is a R helper library for data restructuring

# Broad plan:
# read in the lines as 1 line per observation in a vairable
# ID entries by the ``` between them
# split the observations by the colon
# get rid of the ones without colons
# trim any extra whitespace
# use the column of headings as common headings and the details underneath the headings
# save as csv

# Specific steps
# read in the markdown file as the first column of a data frame (tabular data block)
data.frame(rawlines = readLines("dataexamples.md"), stringsAsFactors = FALSE) %>%
# cumulatively count the entries based on the lines containing ```
  mutate(entry= cumsum(as.numeric(trimws(rawlines) == "```"))) %>%
# split the text on the basis of the first column
  separate(rawlines, into=c("first", "second"), sep=":", extra="merge", fill = "right") %>%
# remove the entries which don't have two parts (so had no colon)
  filter(!is.na(second)) %>%
# remove excess whitespace
  mutate(heading = trimws(first), details = trimws(second)) %>%
# keep the entry number and the trimmed data
  select(entry, heading, details) %>%
# make the entries in the column of headings actual column headings
  spread(heading, details) %>%
# don't need the entry numbers anymore
  select(-entry) %>%
# save as cav file
  write.csv(file = "dataexamples_as_csv.csv", row.names = FALSE)
