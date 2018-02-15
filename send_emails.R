library(ponyexpress) # send the emails

body <- "Dear {name},

Happy Valentine's Day!! We made a special heart just for you :D

<img src = '{github_paths}'> </img>

(As an aside, we randomly generated the text with R and have no idea what we sent to you. Ask Katie 
if you want to know more!)

We love having you in our lives and wanted to take the time to tell you! 


Much love to you <3

Katie, Pippa, and Matthew


<img src = 'https://media.giphy.com/media/26xBRiIYbyjCzYMAU/giphy.gif'> </img>"

df <- emails

df <- rbind(df, c("Katie Jolly", "katiejolly6@gmail.com", "", "", ""))

our_template <- glue::glue(glitter_template)

parcel <- parcel_create(df,
                        sender_name = "Katie Jolly",
                        sender_email = "katiejolly6@gmail.com",
                        subject = "a valentine for you!",
                        template = our_template)

parcel_preview(parcel)     
