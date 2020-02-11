# theme INRAE

theme_inrae <- function(){theme(
  axis.title = element_text(
    family = "Avenir Next Pro",
    size = 13,
    color = "#275662",
    face = "bold"
  ),
  legend.title = element_text(
    family = "Raleway",
    size = 13,
    color = "#275662",
    face = "bold"
  ),
  axis.text = element_text(
    family = "Avenir Next Pro",
    size = 13,
    color = "#275662"
  ),
  legend.text = element_text(
    family = "Avenir Next Pro",
    size = 13,
    color = "#275662"
  ),
  legend.position = "top",
  strip.text = element_text(
    family = "Avenir Next Pro",
    size = 13,
    color = "#275662"
  ),
  plot.title = element_text(
    family = "Raleway",
    size = 20,
    color = "#275662",
  ),
  plot.subtitle = element_text(
    family = "Raleway",
    size = 16,
    color = "#275662",
  ),
  plot.caption = element_text(
    family = "Avenir Next Pro",
    size = 10,
    color = "#275662",
    hjust = 1
  ),
  panel.background = element_rect(
    color = "#275662",
    fill = "white"
  ),
  panel.grid.major.y = element_line(
    color = "grey",
    size = 0.3
  ),
  panel.grid.minor.y = element_line(
    color = "grey",
    size = 0.3,
    linetype = "dashed"
  ),
  panel.grid.minor.x = element_line(
    color = "grey",
    size = 0.3,
    linetype = "dashed"
  ),
)
}

cols_inrae <- c("#00a3a6","#275662","#66c1bf","#008c8e")


scale_fill_inrae <- function(...){
  library(scales)
  discrete_scale("fill","inrae",manual_pal(values = c("#00a3a6","#275662","#66c1bf","#008c8e")), ...)
}

scale_color_inrae <- function(...){
  library(scales)
  discrete_scale("color","inrae",manual_pal(values = c("#00a3a6","#275662","#66c1bf","#008c8e")), ...)
}

scale_colour_inrae <- function(...){
  library(scales)
  discrete_scale("colour","inrae",manual_pal(values = c("#00a3a6","#275662","#66c1bf","#008c8e")), ...)
}



