my_pdfdevice <- function(..., bg='transparent'){
  cairo_pdf(..., bg=bg)
}
knitr::knit_hooks$set(crop = function(...){}) #bug in quarto
knitr::opts_chunk$set(echo = FALSE, message=FALSE, warning = FALSE, dev = 'my_pdfdevice', fig.ext='pdf')
ggplot2::theme_set(ggplot2::theme_minimal(base_size = 18, base_family = 'Gill Sans Nova'))
