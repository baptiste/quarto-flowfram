
library(dplyr)
library(purrr)
library(glue)


library(minisvg)
library(dplyr)
library(purrr)
doc <- minisvg::parse_svg_doc('_layout.svg')
goodchildren <- doc$children[[2]]$children
drop <- sapply(goodchildren, is.character)
newvars <- map_df(goodchildren[!drop], `$`, 'attribs') %>%
  select(x,y,width,height,id) %>%
  na.omit() %>%
  mutate(across(c(x,y,width,height), as.numeric))


newvars


tpl_frame <- '
\\newstaticframe[1]{@width@mm}{@height@mm}
                   {@x@mm}{@55 - height - y@mm}[@id@]
'

.frames <- paste(glue_data(newvars, tpl_frame,
                           .open = '@', .close = '@'),collapse='\n')

cat(.frames, file='_layout.tex')
