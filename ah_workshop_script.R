#1. Attach packages

library(tidyverse)
library(ggridges)
library(gganimate)
library(ggrepel)

# -------------------

# Fox data (and gathering)
# Get data:
ci_fox_pop <- read_csv("ci_fox_pop.csv")

# Gather it:
fox <- ci_fox_pop %>% 
  gather(island, pop, san_miguel:san_nicolas)

####
# --------------------------
####

###My three pieces of advice for getting started (from a gganimate beginner)

# - Make a static version first, ensuring that you can see all of your different states separately (and successfully), possibly using facet_wrap. Then...

# - Start simply, then build animation pieces.

# - Don't do it just because you *can*, do it because it's helps create an engaging visual that is scientifically sound *AND* benefits audience understanding *AND* looks awesome. 

# 1. transition_states: Make a static plot first, then add transitions...

# "[transition_states] splits your data into multiple states based on the levels in a given column, much like ggplot2::facet_wrap() splits up the data in multiple panels. It then tweens (interpolates) between the defined states and pauses at each state." 
ggplot(fox, aes(x = year, y = pop)) +
  geom_point(size = 3, aes(color = island)) +
  theme_dark() +
  labs(x = "Year", y = "Fox Population", title = "Channel Island Fox Recovery") +
  # facet_wrap(~year) # Do this static version first, before...
  transition_states(states = year, transition_length = 1, state_length = 1, wrap = FALSE) + # Do just that first, then add eases and wake
  ease_aes('cubic-in-out') +
  #shadow_wake(wake_length = 0.2) # then change to shadow_mark()
  shadow_mark()

# While waiting to render, show easings.net!

#####
#-----------------------------------
#####

# 2. Fox lines (transition_reveal)

#"We use transition_reveal() to allow the lines to gradually be build up. transition_reveal() knows to only keep old data for path and polygon type layers which means that our segment, point, and text layers only appears as single data points in each frame."

ggplot(fox, aes(x = year, y = pop)) +
  geom_line(size = 1, aes(color = island)) +
  theme_dark() +
  labs(x = "Year", y = "Fox Population", title = "Channel Island Fox Recovery") +
  transition_reveal(id = island, along = year) + # really wants two things...
  ease_aes('quadratic-in-out')

####
#---------------------
####

# Star Wars Data: The 'starwars' dataset exists in dplyr (part of the tidvyerse), with data from the Star Wars API (<https://swapi.co/>). First, look at the data. 

View(starwars)

# Filter to only include data for species: human, droid, wookiee, ewok. Relevel species with forcats' fct_relevel

sw <- starwars %>% 
  filter(species == "Human" | 
           species == "Droid" | 
           species == "Wookiee" | 
           species == "Ewok") %>% 
  mutate(species = factor(species))

sw$species <- fct_relevel(sw$species, "Ewok","Droid","Human","Wookiee")

# Static version first, then animate: 

ggplot(sw, aes(x = height, y = mass, label = name)) +
  geom_point(aes(color = species)) + 
  geom_text_repel(size = 2, segment.color = "gray60", segment.size = 0.2) +
  theme_bw() + # Yeah, looks bad but this is what we want! THEN add transitions... 
  labs(title = "Species: {current_frame}") + # Remember to add this
  transition_manual(frames = species) 


#####
#----------------------------------
#####

# 3. transition_layers (also using starwars)

# "[transition_layers] gradually adds layers to the plot in the order they have been defined. By default prior layers are kept for the remainder of the animation, but they can also be set to be removed as the next layer enters."

ggplot(sw, aes(x = height, y = mass)) +
  geom_point(aes(color = species)) +
  geom_smooth(method = "lm", se = FALSE) +
  geom_smooth(method = "lm", se = TRUE, color = "NA") +
  theme_bw() +
  facet_wrap(~species) + # can do this, but takes longer to render
  transition_layers(layer_length = 1, transition_length = 2) +
  enter_fade()

####
#----------------
####

# Abalone: ridge plots + animation (transition_states)

# Get + wrangle:

abalone <- read_csv("abalone.csv") %>% 
  filter(sex == "M" | sex == "F" | sex == "I") %>% 
  filter(age_years > 4 & age_years < 25) %>% 
  mutate(sex = fct_relevel(as.factor(sex), "I","F","M"))

ggplot(abalone, aes(x = length_mm, y = age_years, fill = sex)) +
  geom_density_ridges(alpha = 0.5, color = "white") +
  scale_fill_manual(values = c("purple","blue","cyan")) +
  theme_minimal() +
  labs(x = "Shell Length (mm)", y = "Abalone Age (years)") +
  transition_states(age_years, transition_length = 1, state_length = 1) +
  shadow_mark()

# Want to save a gif and send it to all your friends? Cool.

# 1. Name it something (like ab_graph <-)

# Then render: 

# animate(ab_graph, nframes = 100, renderer = gifski_renderer("ab_graph.gif"))


###
# ------
###

# Another example (if time):

ggplot(abalone, aes(x = length_mm, y = diameter_mm)) +
  geom_point(aes(color = age_years, size = height_mm)) +
  labs(title = "Abalone age: {closest_state} years", x = "Length (") +
  theme_dark()+
  scale_color_gradientn(colors = c("magenta","orange","yellow","white")) +
  transition_states(age_years, transition_length = 1, state_length = 2) +
  enter_fade() +
  shadow_mark()

###
#-----------
###

# Another extra time example:

ggplot(ChickWeight, aes(x = Chick, y = weight)) +
  geom_col(aes(fill = Diet)) +
  labs(title = "Age (days): {closest_state}") +
  scale_fill_manual(values = c("yellow","orange","coral","magenta")) +
  scale_y_continuous(expand = c(0,0)) +
  theme_dark() +
  transition_states(Time, transition_length = 3, state_length = 1)
