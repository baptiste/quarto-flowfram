
# devtools::install_github("coolbutuseless/minisvg")
library(glue)
library(minisvg)
library(dplyr)
library(purrr)

svg_layout <- function(input = '_layout.svg'){
  
  doc <- minisvg::parse_svg_doc(input)
  svg_main <- data.frame(doc$children[[1]]$attribs[c('width','height')],
                         id='page',x=NA,y=NA)|>
    mutate(across(c(x,y,width,height), as.numeric))
  
  svg_children <- doc$children[[2]]$children
  drop <- sapply(svg_children, is.character)
  layout <- map_df(svg_children[!drop], `$`, 'attribs') |>
    select(x,y,width,height,id) |>
    na.omit() |>
    mutate(across(c(x,y,width,height), as.numeric))
  
  rbind(layout, svg_main)
}

tex_layout <- function(layout, output = '_layout.tex'){
  
  tpl_frame <- '
\\newstaticframe[1]{@width@mm}{@height@mm}{@x@mm}{@y@mm}[@id@]
'
  page_height = layout[layout$id == 'page',]$height
  
  core <- layout[layout$id != 'page',] |> 
    mutate(y = page_height - height - y)
  
  .frames <- paste(glue_data(core, tpl_frame,
                             .open = '@', .close = '@'),collapse='\n')
  
  cat(.frames, file=output)
}


layout <- svg_layout()

# shortcuts
img <- layout[layout$id=='image',]
desc <- layout[layout$id=='description',]
method <- layout[layout$id=='method',]
illust <- layout[layout$id=='illustration',]

