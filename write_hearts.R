library(magick) # image processing
library(googlesheets) # load the data
library(markovifyR) # create markov chain texts
library(tidyverse) # clean the text

heart <- image_read("C:\\Users\\katie\\Documents\\fun_projects\\conversation_hearts\\pink-heart.png")

hearts <- gs_title("conversation_hearts")

sayings <- hearts %>%
  gs_read(ws = 1) 

replacements <- hearts %>%
  gs_read(ws = 2)

sayings$text <- sayings$text %>% # standardize the words
  str_replace_all("[[:punct:]]", "") %>%
  str_replace_all(c( "what" = "wut", " are " = "r", "love" = "luv", " for " = "4", "too " = "2", " to " = "2", "your" = "ur", "you're" = "ur", "thanks" = "thx", "night" = "nite", " you are " = "ur", "you " = "u "))

emails <- hearts %>%
  gs_read(ws = 3) %>%
  filter(!name %in% c("Ruth", "Millie")) %>%
  mutate(email = address) %>%
  select(-address)


model <- generate_markovify_model( # build the text model
  input_text = sayings$text, # use the text as the input
  max_overlap_ratio = 0.85,
  max_overlap_total = 40
)

texts_to_annotate <- markovify_text( # make the strings
  markov_model = model, # use the model we just made
  maximum_sentence_length = NULL, # without a max sentence length
  output_column_name = 'heart_sayings',
  count = 100,
  tries = 600,
  only_distinct = TRUE,
  return_message = TRUE
)

final <- texts_to_annotate %>%
  drop_na() %>%
  sample_n(nrow(emails), replace = TRUE) # make enough for each person on the email list, randomly

emails$text <- final$heart_sayings


heart %>%
  image_scale("600") %>%
  image_annotate(emails$text[[3]], color = "white", gravity = "center", size = 40) # example image

all_paths <- c()

for (i in 1:nrow(emails)){
  path <- paste0("C:\\Users\\katie\\Documents\\conversation_hearts\\images\\", emails$name[[i]], ".png")
  all_paths <- c(all_paths, path)
  img <- heart %>%
            image_scale("600") %>%
            image_annotate(emails$text[[i]], color = "white", gravity = "center", size = 40) %>%
            image_write(path = path, format = "png")

}

emails$path <- all_paths

github_paths <- c()

for (i in 1:nrow(emails)){
  p <- paste0("https://raw.githubusercontent.com/katiejolly/conversation-hearts/master/images/", emails$name[[1]], ".png")
  github_paths <- c(github_paths, p)
}

emails$github_paths <- github_paths # add github paths to images

emails[2, 2] <- "mlh3wb@virginia.edu" # fix M's email

