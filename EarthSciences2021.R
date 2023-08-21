# Earth Sciences

# load in all packages needed
library(RISmed)
library(openxlsx)
library(dplyr)
library(easyPubMed)
library(readxl) 
library(genderizeR)
library(gender)
library(genderdata)
library(readr)
library(splitstackshape)
library(stringr)
library(rvest)
library(semscholar)
# remotes::install_github("njahn82/semscholar")
library(httr)
library(jsonlite)

# 1. Query PubMed to get author order for each journal using RISmed, easypubmed will have the rest of our needed information
# Journals - 
# A. Nature Geoscience
# B. Annual Review of Earth and Planetary Sciences
# C. Earth system science data
# D. Geoscientific Model Development
# E. Journal of Advances in Modeling Earth Systems

# 2. Query PubMed to get author affiliation, DOI, and misc info using easypubmed
# A. Nature Geoscience
# B. Annual Review of Earth and Planetary Sciences
# C. Earth system science data
# D. Geoscientific Model Development
# E. Journal of Advances in Modeling Earth Systems

# 3. Combine author results from easypubmed and RISmed

# 4. Return citation count from Semantic Scholar's API for each article

# 5. Assign Gender using 2 different methods, then take consensus
# A. gender package
# B. genderizeR package - from genderize API
# C. consensus

# 1A - Download records of Nature geoscience from PubMed and package RISmed

# creates an object with a query that fits the PubMed format
# done in PubMed beforehand to verify
my_query <- '("Nature geoscience"[Journal]) AND (("2021/10/21"[Date - Publication] : "2021/12/31"[Date - Publication]))'
# gets summary of information from PubMed for the query
NGSdata <- EUtilsSummary(my_query, mindate = 2021, maxdate = 2021)
summary(NGSdata)
# downloads records from the NCBI
NGSrecords <- EUtilsGet(NGSdata)

# gets the titles from the downloaded record of the query
NGSTitles <- data.frame("Title" = ArticleTitle(NGSrecords), "PMID" = PMID(NGSrecords))
# indexes titles to be able to assign to authors
NGSTitles$index <- 1:nrow(NGSTitles)

# grabs the authors from the downloaded data
NGSAuthors <- Author(NGSrecords)
# binds rows of authors so that all are in one df
NGSAuthors <- bind_rows(NGSAuthors)

# indexes authors 
count <- 0
for(val in 1:nrow(NGSAuthors))
{if(NGSAuthors$order[val] == 1){ count <- count + 1 
NGSAuthors$index[val] <- count}
  else {NGSAuthors$index[val] <- count}}

# assigns articles to authors by index
NGSAuthors <- merge(NGSAuthors, NGSTitles, by = "index")

# All code for section 1 follows same reasoning/code as above

# 1B - Download records of Annual Review of Earth and Planetary Sciences from PubMed and package RISmed

my_query2 <- '("Annual Review of Earth and Planetary Sciences"[Journal]) AND (("2021/10/21"[Date - Publication] : "2021/12/31"[Date - Publication]))'
AREPSdata <- EUtilsSummary(my_query2, mindate = 2021, maxdate = 2021)
summary(AREPSdata)
AREPSrecords <- EUtilsGet(AREPSdata)

AREPSTitles <- data.frame("Title" = ArticleTitle(AREPSrecords), "PMID" = PMID(AREPSrecords))
AREPSTitles$index <- 1:nrow(AREPSTitles)

AREPSAuthors <- Author(AREPSrecords)
AREPSAuthors <- bind_rows(AREPSAuthors)

count <- 0
for(val in 1:nrow(AREPSAuthors))
{if(AREPSAuthors$order[val] == 1){ count <- count + 1 
AREPSAuthors$index[val] <- count}
  else {AREPSAuthors$index[val] <- count}}

AREPSAuthors <- merge(AREPSAuthors, AREPSTitles, by = "index")

# 1C - Download records of Earth system science data from PubMed and package RISmed

my_query3 <- '("Earth system science data"[Journal]) AND (("2021/10/21"[Date - Publication] : "2021/12/31"[Date - Publication]))'
ESSDdata <- EUtilsSummary(my_query3, mindate = 2021, maxdate = 2021)
summary(ESSDdata)
ESSDrecords <- EUtilsGet(ESSDdata)

ESSDTitles <- data.frame("Title" = ArticleTitle(ESSDrecords), "PMID" = PMID(ESSDrecords))
ESSDTitles$index <- 1:nrow(ESSDTitles)

ESSDAuthors <- Author(ESSDrecords)
ESSDAuthors <- bind_rows(ESSDAuthors)

count <- 0
for(val in 1:nrow(ESSDAuthors))
{if(ESSDAuthors$order[val] == 1){ count <- count + 1 
ESSDAuthors$index[val] <- count}
  else {ESSDAuthors$index[val] <- count}}

ESSDAuthors <- merge(ESSDAuthors, ESSDTitles, by = "index")

# 1D - Download records of Geoscientific Model Development data from PubMed and package RISmed

my_query4 <- '("Geoscientific Model Development"[Journal]) AND (("2021/10/21"[Date - Publication] : "2021/12/31"[Date - Publication]))'
GMDdata <- EUtilsSummary(my_query4, mindate = 2021, maxdate = 2021)
summary(GMDdata)
GMDrecords <- EUtilsGet(GMDdata)

GMDTitles <- data.frame("Title" = ArticleTitle(GMDrecords), "PMID" = PMID(GMDrecords))
GMDTitles$index <- 1:nrow(GMDTitles)

GMDAuthors <- Author(GMDrecords)
GMDAuthors <- bind_rows(GMDAuthors)

count <- 0
for(val in 1:nrow(GMDAuthors))
{if(GMDAuthors$order[val] == 1){ count <- count + 1 
GMDAuthors$index[val] <- count}
  else {GMDAuthors$index[val] <- count}}

GMDAuthors <- merge(GMDAuthors, GMDTitles, by = "index")

# 1E - Download records of Journal of Advances in Modeling Earth Systems data from PubMed and package RISmed

my_query5 <- '("Journal of Advances in Modeling Earth Systems"[Journal]) AND (("2021/10/21"[Date - Publication] : "2021/12/31"[Date - Publication]))'
JAMESdata <- EUtilsSummary(my_query5, mindate = 2021, maxdate = 2021)
summary(JAMESdata)
JAMESrecords <- EUtilsGet(JAMESdata)

JAMESTitles <- data.frame("Title" = ArticleTitle(JAMESrecords), "PMID" = PMID(JAMESrecords))
JAMESTitles$index <- 1:nrow(JAMESTitles)

JAMESAuthors <- Author(JAMESrecords)
JAMESAuthors <- bind_rows(JAMESAuthors)

count <- 0
for(val in 1:nrow(JAMESAuthors))
{if(JAMESAuthors$order[val] == 1){ count <- count + 1 
JAMESAuthors$index[val] <- count}
  else {JAMESAuthors$index[val] <- count}}

JAMESAuthors <- merge(JAMESAuthors, JAMESTitles, by = "index")

# Combines all authors into one dataframe
EarthAuth <- bind_rows(NGSAuthors, JAMESAuthors)

# creates a unique column so we can merge later with easypubmed data
EarthAuth$Unique <- paste(EarthAuth$ForeName, EarthAuth$LastName, EarthAuth$PMID, sep = "")

# Splits the ForeName column so that we only have the first name 
# and we can correctly assign genders to names later
EarthAuth <- cSplit(EarthAuth, "ForeName", sep = " ")
# renames columns
EarthAuth <- rename(EarthAuth, ForeName = ForeName_1,
                      Middle1 = ForeName_2)

# 2. Queries PubMed to get author affiliation, DOI, and misc info using easypubmed
# A. Nature Geoscience
# B. Annual Review of Earth and Planetary Sciences
# C. Earth system science data
# D. Geoscientific Model Development
# E. Journal of Advances in Modeling Earth Systems

# 2A - Nature Geoscience

# gets ids from pubmed 
NG_on_pubmed <- get_pubmed_ids(my_query)
# fetches author data from pubmed ids
NG_abstracts_xml <- fetch_pubmed_data(NG_on_pubmed, retmax = 500)
# creates a df of authors from the author data
NGAuthorsEPM <- table_articles_byAuth(NG_abstracts_xml)

# 2B - Annual Review of Earth and Planetary Sciences
AREPS_on_pubmed <- get_pubmed_ids(my_query2)
AREPS_abstracts_xml <- fetch_pubmed_data(AREPS_on_pubmed, retmax = 500)
AREPSAuthorsEPM <- table_articles_byAuth(AREPS_abstracts_xml)

# 2C - Earth system science data
ESSD_on_pubmed <- get_pubmed_ids(my_query3)
ESSD_abstracts_xml <- fetch_pubmed_data(ESSD_on_pubmed, retmax = 500)
ESSDAuthorsEPM <- table_articles_byAuth(ESSD_abstracts_xml)

# 2D - Geoscientific Model Development
GMD_on_pubmed <- get_pubmed_ids(my_query4)
GMD_abstracts_xml <- fetch_pubmed_data(GMD_on_pubmed, retmax = 500)
GMDAuthorsEPM <- table_articles_byAuth(GMD_abstracts_xml)

# 2E - Journal of Advances in Modeling Earth Systems
JAMES_on_pubmed <- get_pubmed_ids(my_query5)
JAMES_abstracts_xml <- fetch_pubmed_data(JAMES_on_pubmed, retmax = 500)
JAMESAuthorsEPM <- table_articles_byAuth(JAMES_abstracts_xml)

# binds all authors into the same df
EarthAuthEPM <- bind_rows(NGAuthorsEPM, JAMESAuthorsEPM)

# creates a unique column of EPM authors so we can merge with RISmed ones
EarthAuthEPM$Unique <- paste(EarthAuthEPM$firstname, EarthAuthEPM$lastname, EarthAuthEPM$pmid, sep = "")

# saves file so we can reformat and get rid of weird symbols
write.csv(EarthAuthEPM, file = "EarthAuthEPM.csv")
# change to ANSI
# can do this by opening up a notebook and changing the formatting when saving
EarthAuthEPM <- read.csv(file = "EarthAuthEPM.csv")

# splits the ForeName column so that we only have the first name and no middle names/initials
EarthAuthEPM <- cSplit(EarthAuthEPM, "firstname_1", sep = " ")
# renames columns
EarthAuthEPM <- rename(EarthAuthEPM, ForeName = firstname_1_1)

# 3 - Combining results from both easypubmed and RISmed

# removes NAs from both dfs
EarthAuth[is.na(EarthAuth)] <- ""
EarthAuthEPM[is.na(EarthAuthEPM)] <- ""

# merges RISmed and easypubmed authors into a new df
EarthAuthMix <- merge(EarthAuth, EarthAuthEPM, by = "Unique", all.x = F, all.y = T)

# rename the columns to match
EarthAuth <- data.frame("ForeName" = EarthAuthMix$ForeName.x, "Middle1" = EarthAuthMix$Middle1,
                         "LastName" = EarthAuthMix$LastName,
                          "Order" = EarthAuthMix$order, "Title" = EarthAuthMix$Title,
                          "PMID" = EarthAuthMix$PMID, "DOI" = EarthAuthMix$doi,
                          "Journal" = EarthAuthMix$journal)

# 4 - returns citation count from Semantic Scholar's API for each article

# creates new df with just the DOI so we can collapse so we don't have to look up
# duplicated DOIs for different authors
EarthAuthDOI <- data.frame("DOI" = EarthAuth$DOI)
# collapses DOIs to be unique
EarthAuthDOI <- unique(EarthAuthDOI)
# goes through all DOI's and returns the citation count as a new
# new column in the DOI df
empty <- ""
for(val in 1:3)
{empty <- s2_papers(EarthAuthDOI$DOI[val])
EarthAuthDOI$TitleSem[val] <- empty$title
empty <- empty$citations
empty <- bind_rows(empty)
EarthAuthDOI$CitationCount[val] <- nrow(empty)}

# removes row that was empty, helps with merging later
EarthAuthDOI <- EarthAuthDOI[-59,]

# assigns citation counts back to authors
EarthAuth <- merge(EarthAuth, EarthAuthDOI, by = "DOI", all.x = TRUE)

write.csv(EarthAuth, file = "EarthAuthCitations.csv")

EarthAuth <- read.csv(file = "EarthAuthCitations.csv")

# Title Dates
# manually

# 5 - Assign Gender using 4 different methods, then take consensus

# 5A - Self curated gender assignment
# reads in data of names and genders and proportions
NAG <- read.csv(file = "ListofNamesandGend.csv")
# assigns gender by name
EarthAuth <- merge(EarthAuth, unique(NAG), by.x = "ForeName",
                        by.y = "name", all.x = TRUE, all.y = FALSE)
# saves work
write.csv(EarthAuth, file = "EarthAuth.csv")

# 5B - Harvard Dataverse's World gender name dictionary

# reads in earth science authors 
EarthAuth <- read.csv(file = "EarthAuthCitations.csv")
# reads in WGND data
wgnd <- read.delim("wgndnames.tab", header = TRUE)
# takes only needed columns
wgnd <- data.frame("name" = wgnd$name, "gender" = wgnd$gender, "n" = wgnd$nobs)
# makes the name proper
wgnd$name <- str_to_title(wgnd$name)
# groups by name and gender to collapse multiple names that exist in the df
wgnd <- wgnd %>% group_by(name, gender) %>%
  summarise(n = sum(n))
# creates a df with the total appearing per name
wgndtotal <- wgnd %>% group_by(name) %>% 
  summarise(ntotal = sum(n))
# merges the total column to the original dataframe
wgndtrial <- merge(wgnd, unique(wgndtotal), by = "name")
# takes the proportion gender per name
wgnd$prop = wgndtrial$n / wgndtrial$ntotal
# Only takes the higher proportion gender per name
wgnd <- wgnd[which(wgnd$prop > .50),]
# removes where it may have assigned gender to initials
# not sure if there is an easier way to do this
wgnd <- wgnd[which(wgnd$name != "A" & wgnd$name != "B" & 
                     wgnd$name != "C" & wgnd$name != "D" &
                     wgnd$name != "E" & wgnd$name != "F" &
                     wgnd$name != "G" & wgnd$name != "H" &
                     wgnd$name != "I" & wgnd$name != "J" &
                     wgnd$name != "K" & wgnd$name != "L" &
                     wgnd$name != "M" & wgnd$name != "N" &
                     wgnd$name != "O" & wgnd$name != "P" &
                     wgnd$name != "Q" & wgnd$name != "R" &
                     wgnd$name != "S" & wgnd$name != "T" &
                     wgnd$name != "U" & wgnd$name != "V" &
                     wgnd$name != "W" & wgnd$name != "X" &
                     wgnd$name != "Y" & wgnd$name != "Z"),]
# assigns gender to name
EarthAuth <- merge(EarthAuth, unique(wgnd), by.x = "ForeName",
                        by.y = "name", all.x = TRUE, all.y = FALSE)
# saves work
write.csv(EarthAuth, file = "EarthAuthWGNDGender.csv")

# 5C - gender package

# reads in earth science authors
EarthAuth <- read.csv(file = "EarthAuthCitations.csv")
# creates a new vector with just names
x <- EarthAuth$ForeName
# calls the gender package which assigns gender
x <- gender(x)
# assigns genders to earth sciences authors
EarthAuth <- merge(EarthAuth, unique(x), by.x = "ForeName", by.y = "name",
                     all.x = TRUE, all.y = FALSE)
# saves work
write.csv(EarthAuth, file = "EarthAuthgenderpackage.csv")

# 5D - genderizeR package - from genderize API

# creates a new vector with just forenames
newEarthAuth <- EarthAuth$ForeName
# finds the given name from the column - unnecessary but package calls for it
EarthAuthGivenNames <- findGivenNames(newEarthAuth)
# assigns genders to the names
EarthAuthGender <- genderize(newEarthAuth, EarthAuthGivenNames)
EarthAuthGender <- data.frame("ForeName" = EarthAuthGender$text,
                                "Gender" = EarthAuthGender$gender)
# assigns genders to our authors names
x <- merge(EarthAuth, unique(EarthAuthGender), by.x = "ForeName",
           by.y = "ForeName", all.x = TRUE, all.y = FALSE)
write.csv(x, file = "EarthAuthgenderizeR.csv")

# 5E - take consensus

EarthAuthSelf <- read.csv(file = "EarthAuth.csv")
EarthAuthWGND <- read.csv(file = "EarthAuthWGNDGender.csv")
EarthAuthPack <- read.csv(file = "EarthAuthgenderpackage.csv")
EarthAuthGenderizeR <- read.csv(file = "EarthAuthgenderizeR.csv")
EarthAuth <- read.csv(file = "EarthAuthCitations.csv")

# Creates a unique column to merge by
EarthAuthSelf$Unique <- paste(EarthAuthSelf$ForeName, EarthAuthSelf$LastName, EarthAuthSelf$PMID, sep = "")
EarthAuthSelf <- data.frame("Unique" = EarthAuthSelf$Unique, "SelfGender" = EarthAuthSelf$gender)
EarthAuthWGND$Unique <- paste(EarthAuthWGND$ForeName, EarthAuthWGND$LastName,EarthAuthWGND$PMID, sep = "")
EarthAuthWGND <- data.frame("Unique" = EarthAuthWGND$Unique, "WGNDGender" = EarthAuthWGND$gender)
EarthAuthPack$Unique <- paste(EarthAuthPack$ForeName, EarthAuthPack$LastName,EarthAuthPack$PMID, sep = "")
EarthAuthPack <- data.frame("Unique" = EarthAuthPack$Unique, "PackGender" = EarthAuthPack$gender)
EarthAuthGenderizeR$Unique <- paste(EarthAuthGenderizeR$ForeName, EarthAuthGenderizeR$LastName,EarthAuthGenderizeR$PMID, sep = "")
EarthAuthGenderizeR <- data.frame("Unique" = EarthAuthGenderizeR$Unique, "GenderizeRGender" = EarthAuthGenderizeR$gender)
EarthAuth$Unique <- paste(EarthAuth$ForeName, EarthAuth$LastName, EarthAuth$PMID,sep = "")

# adds the assignment of gender for each method to our original author dataset
EarthAuth <- merge(EarthAuth, EarthAuthSelf, by = "Unique", all.x = T, all.y = F)
EarthAuth <- merge(EarthAuth, EarthAuthWGND, by = "Unique")
EarthAuth <- merge(EarthAuth, EarthAuthPack, by = "Unique")
EarthAuth <- merge(EarthAuth, EarthAuthGenderizeR, by = "Unique")

# renames gender so that format is consistent
EarthAuth$PackGender[which(EarthAuth$PackGender == "female")] <- "F"
EarthAuth$PackGender[which(EarthAuth$PackGender == "male")] <- "M"
EarthAuth$GenderizeRGender[which(EarthAuth$GenderizeRGender == "female")] <- "F"
EarthAuth$GenderizeRGender[which(EarthAuth$GenderizeRGender == "male")] <- "M"

# removes NAs 
EarthAuth[is.na(EarthAuth)] <- ""
# concatenates all of the genders into one column, so that we can find the consensus
EarthAuth$GenderCon <- paste(EarthAuth$SelfGender, EarthAuth$WGNDGender, EarthAuth$PackGender,
                               EarthAuth$GenderizeRGender, sep = "")

# removes any nonconsensus genders (granted at least two methods have assigned a gender for that name)
for(val in 1:nrow(EarthAuth))
{ 
  if(EarthAuth$GenderCon[val] == "MM" | EarthAuth$GenderCon[val] == "MMM" |
     EarthAuth$GenderCon[val] == "MMMM" | EarthAuth$GenderCon[val] == "FF" |
     EarthAuth$GenderCon[val] == "FFF" | EarthAuth$GenderCon[val] == "FFFF")
  {EarthAuth$GenderCon[val] <- EarthAuth$GenderCon[val]}
  else {EarthAuth$GenderCon[val] <- ""}
}

# reformats gender
for(val in 1:nrow(EarthAuth))
{if(EarthAuth$GenderCon[val] == "MM" | EarthAuth$GenderCon[val] == "MMM" | 
    EarthAuth$GenderCon[val] == "MMMM")
  EarthAuth$GenderCon[val] <- "M"
}

for(val in 1:nrow(EarthAuth))
{
  if(EarthAuth$GenderCon[val] == "FF"|
     EarthAuth$GenderCon[val] == "FFF" | EarthAuth$GenderCon[val] == "FFFF")
    EarthAuth$GenderCon[val] <- "F"
}

# takes all columns we need
EarthAuth <- data.frame("ForeName" = EarthAuth$ForeName, "Middle1" = EarthAuth$Middle1,
                          "Middle2" = EarthAuth$Middle2, "LastName" = EarthAuth$LastName,
                          "Order" = EarthAuth$Order, "Title" = EarthAuth$Title,
                          "PMID" = EarthAuth$PMID, "DOI" = EarthAuth$DOI,
                          "Journal" = EarthAuth$Journal, "Address" = EarthAuth$Address,
                          "CitationCount" = EarthAuth$CitationCount, "Gender" = EarthAuth$GenderCon
)

EarthAuth <- unique(EarthAuth)

write.csv(EarthAuth, file = "EarthAuthFinal.csv")

# new journal Earth and Planetary Science Letters
# and Earth's future - R script is exact same as above

my_query6 <- '("Earth and Planetary Science Letters"[Journal]) AND (("2011"[Date - Publication] : "3000"[Date - Publication]))'
EPSLdata <- EUtilsSummary(my_query6, mindate = 2011, maxdate = 2021)
summary(EPSLdata)
EPSLrecords <- EUtilsGet(EPSLdata)

EPSLTitles <- data.frame("Title" = ArticleTitle(EPSLrecords), "PMID" = PMID(EPSLrecords))
EPSLTitles$index <- 1:nrow(EPSLTitles)

EPSLAuthors <- Author(EPSLrecords)
EPSLAuthors <- bind_rows(EPSLAuthors)

count <- 0
for(val in 1:nrow(EPSLAuthors))
{if(EPSLAuthors$order[val] == 1){ count <- count + 1 
EPSLAuthors$index[val] <- count}
  else {EPSLAuthors$index[val] <- count}}

EPSLAuthors <- merge(EPSLAuthors, EPSLTitles, by = "index")

my_query7 <- '("Earth\'s future"[Journal]) AND (("2011"[Date - Publication] : "3000"[Date - Publication]))'
EFdata <- EUtilsSummary(my_query7, mindate = 2011, maxdate = 2021)
summary(EFdata)
EFrecords <- EUtilsGet(EFdata)

EFTitles <- data.frame("Title" = ArticleTitle(EFrecords), "PMID" = PMID(EFrecords))
EFTitles$index <- 1:nrow(EFTitles)

EFAuthors <- Author(EFrecords)
EFAuthors <- bind_rows(EFAuthors)

count <- 0
for(val in 1:nrow(EFAuthors))
{if(EFAuthors$order[val] == 1){ count <- count + 1 
EFAuthors$index[val] <- count}
  else {EFAuthors$index[val] <- count}}

EFAuthors <- merge(EFAuthors, EFTitles, by = "index")

EarthAuth2 <- bind_rows(EFAuthors, EPSLAuthors)

EarthAuth2$Unique <- paste(EarthAuth2$ForeName, EarthAuth2$LastName, EarthAuth2$PMID, sep = "")

EarthAuth2 <- cSplit(EarthAuth2, "ForeName", sep = " ")

EarthAuth2 <- rename(EarthAuth2, ForeName = ForeName_1,
                    Middle1 = ForeName_2, Middle2 = ForeName_3)

# easypubmed query

EPSL_on_pubmed <- get_pubmed_ids(my_query6)
EPSL_abstracts_xml <- fetch_pubmed_data(EPSL_on_pubmed, retmax = 500)
EPSLAuthorsEPM <- table_articles_byAuth(EPSL_abstracts_xml)

EF_on_pubmed <- get_pubmed_ids(my_query7)
EF_abstracts_xml <- fetch_pubmed_data(EF_on_pubmed, retmax = 500)
EFAuthorsEPM <- table_articles_byAuth(EF_abstracts_xml)


EarthAuthEPM2 <- bind_rows(EPSLAuthorsEPM, EFAuthorsEPM)

EarthAuthEPM2$Unique <- paste(EarthAuthEPM2$firstname, EarthAuthEPM2$lastname, EarthAuthEPM2$pmid, sep = "")

write.csv(EarthAuthEPM2, file = "EarthAuthEPM2.csv")
EarthAuthEPM2 <- read_csv("EarthAuthEPM2.csv")

EarthAuthEPM2 <- cSplit(EarthAuthEPM2, "firstname", sep = " ")
EarthAuthEPM2 <- rename(EarthAuthEPM2, ForeName = firstname_1,
                       Middle1 = firstname_2, Middle2 = firstname_3)


EarthAuth2[is.na(EarthAuth2)] <- ""
EarthAuthEPM2[is.na(EarthAuthEPM2)] <- ""

EarthAuthMix2 <- merge(EarthAuth2, EarthAuthEPM2, by = "Unique", all.x = T, all.y = F)

EarthAuth2 <- data.frame("ForeName" = EarthAuthMix2$ForeName.x, "Middle1" = EarthAuthMix2$Middle1.x,
                        "Middle2" = EarthAuthMix2$Middle2.x, "LastName" = EarthAuthMix2$LastName,
                        "Order" = EarthAuthMix2$order, "Title" = EarthAuthMix2$Title,
                        "PMID" = EarthAuthMix2$PMID, "DOI" = EarthAuthMix2$doi,
                        "Journal" = EarthAuthMix2$journal, "Address" = EarthAuthMix2$address)

EarthAuthDOI2 <- data.frame("DOI" = EarthAuth2$DOI)

EarthAuthDOI2 <- unique(EarthAuthDOI2)

empty <- ""

for(val in 1:nrow(EarthAuthDOI2))
{Link <- paste("https://api.semanticscholar.org/v1/paper/", EarthAuthDOI2$DOI[val], sep = "")
JSONDOI <- GET(Link)
JSONDataDOI <- fromJSON(rawToChar(JSONDOI$content))
EarthAuthDOI2$CitationCount[val] <- JSONDataDOI$numCitedBy
}

EarthAuth2 <- merge(EarthAuth2, EarthAuthDOI2, by = "DOI", all.x = TRUE)

write.csv(EarthAuth2, file = "EarthAuthCitations2.csv")

EarthAuth2 <- read.csv(file = "EarthAuthCitations2.csv")

NAG <- read.csv(file = "ListofNamesandGend.csv")
EarthAuth2 <- merge(EarthAuth2, unique(NAG), by.x = "ForeName",
                    by.y = "name", all.x = TRUE, all.y = FALSE)

write.csv(EarthAuth2, file = "EarthAuth2.csv")

EarthAuth2 <- read.csv(file = "EarthAuthCitations2.csv")
wgnd <- read.delim("wgndnames.tab", header = TRUE)
wgnd <- data.frame("name" = wgnd$name, "gender" = wgnd$gender, "n" = wgnd$nobs)
wgnd$name <- str_to_title(wgnd$name)
wgnd <- wgnd %>% group_by(name, gender) %>%
  summarise(n = sum(n))
wgndtotal <- wgnd %>% group_by(name) %>% 
  summarise(ntotal = sum(n))
wgndtrial <- merge(wgnd, unique(wgndtotal), by = "name")
wgnd$prop = wgndtrial$n / wgndtrial$ntotal
wgnd <- wgnd[which(wgnd$prop > .50),]
wgnd <- wgnd[which(wgnd$name != "A" & wgnd$name != "B" & 
                     wgnd$name != "C" & wgnd$name != "D" &
                     wgnd$name != "E" & wgnd$name != "F" &
                     wgnd$name != "G" & wgnd$name != "H" &
                     wgnd$name != "I" & wgnd$name != "J" &
                     wgnd$name != "K" & wgnd$name != "L" &
                     wgnd$name != "M" & wgnd$name != "N" &
                     wgnd$name != "O" & wgnd$name != "P" &
                     wgnd$name != "Q" & wgnd$name != "R" &
                     wgnd$name != "S" & wgnd$name != "T" &
                     wgnd$name != "U" & wgnd$name != "V" &
                     wgnd$name != "W" & wgnd$name != "X" &
                     wgnd$name != "Y" & wgnd$name != "Z"),]
EarthAuth2 <- merge(EarthAuth2, unique(wgnd), by.x = "ForeName",
                    by.y = "name", all.x = TRUE, all.y = FALSE)
write.csv(EarthAuth2, file = "EarthAuth2WGNDGender.csv")


EarthAuth2 <- read.csv(file = "EarthAuthCitations2.csv")
x <- EarthAuth2$ForeName
x <- gender(x)
EarthAuth2 <- merge(EarthAuth2, unique(x), by.x = "ForeName", by.y = "name",
                    all.x = TRUE, all.y = FALSE)
write.csv(EarthAuth2, file = "EarthAuth2genderpackage.csv")

EarthAuth2 <- read.csv(file = "EarthAuthCitations2.csv")
newEarthAuth2 <- EarthAuth2$ForeName
EarthAuth2GivenNames <- findGivenNames(newEarthAuth2)
EarthAuth2Gender <- genderize(newEarthAuth2, EarthAuth2GivenNames)
EarthAuth2Gender <- data.frame("ForeName" = EarthAuth2Gender$text,
                               "Gender" = EarthAuth2Gender$gender)
x <- merge(EarthAuth2, unique(EarthAuth2Gender), by.x = "ForeName",
           by.y = "ForeName", all.x = TRUE, all.y = FALSE)
write.csv(x, file = "EarthAuth2genderizeR.csv")

EarthAuth2Self <- read.csv(file = "EarthAuth2.csv")
EarthAuth2WGND <- read.csv(file = "EarthAuth2WGNDGender.csv")
EarthAuth2Pack <- read.csv(file = "EarthAuth2genderpackage.csv")
EarthAuth2GenderizeR <- read.csv(file = "EarthAuth2genderizeR.csv")
EarthAuth2 <- read.csv(file = "EarthAuth2Citations.csv")

EarthAuth2Self$Unique <- paste(EarthAuth2Self$ForeName, EarthAuth2Self$LastName, EarthAuth2Self$PMID, sep = "")
EarthAuth2Self <- data.frame("Unique" = EarthAuth2Self$Unique, "SelfGender" = EarthAuth2Self$gender)
EarthAuth2WGND$Unique <- paste(EarthAuth2WGND$ForeName, EarthAuth2WGND$LastName,EarthAuth2WGND$PMID, sep = "")
EarthAuth2WGND <- data.frame("Unique" = EarthAuth2WGND$Unique, "WGNDGender" = EarthAuth2WGND$gender)
EarthAuth2Pack$Unique <- paste(EarthAuth2Pack$ForeName, EarthAuth2Pack$LastName,EarthAuth2Pack$PMID, sep = "")
EarthAuth2Pack <- data.frame("Unique" = EarthAuth2Pack$Unique, "PackGender" = EarthAuth2Pack$gender)
EarthAuth2GenderizeR$Unique <- paste(EarthAuth2GenderizeR$ForeName, EarthAuth2GenderizeR$LastName,EarthAuth2GenderizeR$PMID, sep = "")
EarthAuth2GenderizeR <- data.frame("Unique" = EarthAuth2GenderizeR$Unique, "GenderizeRGender" = EarthAuth2GenderizeR$gender)
EarthAuth2$Unique <- paste(EarthAuth2$ForeName, EarthAuth2$LastName, EarthAuth2$PMID,sep = "")

EarthAuth2 <- merge(EarthAuth2, EarthAuth2Self, by = "Unique", all.x = T, all.y = F)
EarthAuth2 <- merge(EarthAuth2, EarthAuth2WGND, by = "Unique")
EarthAuth2 <- merge(EarthAuth2, EarthAuth2Pack, by = "Unique")
EarthAuth2 <- merge(EarthAuth2, EarthAuth2GenderizeR, by = "Unique")

EarthAuth2$PackGender[which(EarthAuth2$PackGender == "female")] <- "F"
EarthAuth2$PackGender[which(EarthAuth2$PackGender == "male")] <- "M"
EarthAuth2$GenderizeRGender[which(EarthAuth2$GenderizeRGender == "female")] <- "F"
EarthAuth2$GenderizeRGender[which(EarthAuth2$GenderizeRGender == "male")] <- "M"

EarthAuth2[is.na(EarthAuth2)] <- ""
EarthAuth2$GenderCon <- paste(EarthAuth2$SelfGender, EarthAuth2$WGNDGender, EarthAuth2$PackGender,
                              EarthAuth2$GenderizeRGender, sep = "")

for(val in 1:nrow(EarthAuth2))
{ 
  if(EarthAuth2$GenderCon[val] == "MM" | EarthAuth2$GenderCon[val] == "MMM" |
     EarthAuth2$GenderCon[val] == "MMMM" | EarthAuth2$GenderCon[val] == "FF" |
     EarthAuth2$GenderCon[val] == "FFF" | EarthAuth2$GenderCon[val] == "FFFF")
  {EarthAuth2$GenderCon[val] <- EarthAuth2$GenderCon[val]}
  else {EarthAuth2$GenderCon[val] <- ""}
}

for(val in 1:nrow(EarthAuth2))
{if(EarthAuth2$GenderCon[val] == "MM" | EarthAuth2$GenderCon[val] == "MMM" | 
    EarthAuth2$GenderCon[val] == "MMMM")
  EarthAuth2$GenderCon[val] <- "M"
}

for(val in 1:nrow(EarthAuth2))
{
  if(EarthAuth2$GenderCon[val] == "FF"|
     EarthAuth2$GenderCon[val] == "FFF" | EarthAuth2$GenderCon[val] == "FFFF")
    EarthAuth2$GenderCon[val] <- "F"
}

EarthAuth2 <- data.frame("ForeName" = EarthAuth2$ForeName, "Middle1" = EarthAuth2$Middle1,
                         "Middle2" = EarthAuth2$Middle2, "LastName" = EarthAuth2$LastName,
                         "Order" = EarthAuth2$Order, "Title" = EarthAuth2$Title,
                         "PMID" = EarthAuth2$PMID, "DOI" = EarthAuth2$DOI,
                         "Journal" = EarthAuth2$Journal, "Address" = EarthAuth2$Address,
                         "CitationCount" = EarthAuth2$CitationCount, "Gender" = EarthAuth2$GenderCon
)

EarthAuth2 <- unique(EarthAuth2)

write.csv(EarthAuth2, "EarthAuthFinal2.csv")

# take sample
EarthAuth2 <- read.csv("EarthAuthFinal2.csv")
EarthAuth <- read.csv("EarthAuth.csv")

EarthAuth <- EarthAuth[which(EarthAuth$Journal != "Earth system science data" & EarthAuth$Journal != "Annual review of earth and planetary sciences"),]
EarthAuthFinal <- bind_rows(EarthAuth, EarthAuth2)

write.csv("EarthAuthFinal3.csv")

# 242 unique articles