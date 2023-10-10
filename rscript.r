# Load necessary libraries
library(gender)
library(dplyr)
library(ggplot2)

# Read in your dataset
df <- read.csv("MED_Crossreff_pull_25.csv")

# Function to clean and validate a name, including transliteration of non-ASCII characters
clean_and_validate_name <- function(name) {
  if (is.na(name) || name == "") {
    return(NA)
  } else {
    # Transliterate non-ASCII characters to ASCII
    cleaned_name <- iconv(name, from = "UTF-8", to = "ASCII//TRANSLIT")
    # Remove any remaining non-alphabetic characters
    cleaned_name <- gsub("[^a-zA-Z ]", "", cleaned_name)
    return(cleaned_name)
  }
}

# Preprocess names and apply to entire dataframe
df$gender_pred <- sapply(df$Author.First.Name, function(name) {
  cleaned_name <- clean_and_validate_name(name)
  if (is.na(cleaned_name)) {
    return(NA)
  }
  
  result <- tryCatch({
    res <- gender(cleaned_name, method = "ssa")
    if (nrow(res) > 0) {
      return(res$gender[1]) 
    } else {
      return(NA)
    }
  }, error = function(e) NA)
  
  return(result)
})

# Plotting the distribution of genders
ggplot(df, aes(x = gender_pred)) + 
  geom_bar() + 
  labs(title = "Distribution of Predicted Genders", 
       x = "Gender", 
       y = "Count") +
  theme_minimal()
