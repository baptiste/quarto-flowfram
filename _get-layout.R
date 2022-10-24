
# devtools::install_github("coolbutuseless/minisvg")
library(minisvg)
library(dplyr)
library(purrr)
doc <- minisvg::parse_svg_doc('_layout.svg')

goodchildren <- doc$children[[2]]$children
drop <- sapply(goodchildren, is.character)
layout <- map_df(goodchildren[!drop], `$`, 'attribs') %>%
  select(x,y,width,height,id) %>%
  na.omit() %>%
  mutate(across(c(x,y,width,height), as.numeric))

layout


# shortcuts
img <- layout[layout$id=='image',]

