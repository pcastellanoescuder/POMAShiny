# This file is part of POMA.

# POMA is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMA. If not, see <https://www.gnu.org/licenses/>.

## Packages:
library(ggplot2)
library(png)
library(grid)
library(hexSticker)

## Settings:
col_bg <- "#336B87"   
col_border <- "#f2541b"  
col_text <- "#F2F1EF"    

n_steps <- 60
y_min <- 1.2
y_max <- 1.6
x_min <- 0.0
x_max <- 1.1

## Read the drawing:
img <- readPNG("poma.png")
g_img <- rasterGrob(img, width = 0.64, x = 0.5, interpolate = TRUE)

## Rectangle with color shade to transparency:
ys <- seq(y_min, y_max, length.out = n_steps + 1)
alpha_steps <- seq(from = 0, to = 0.5, length.out = n_steps)
trans_df <- data.frame(xmin = x_min, xmax = x_max, ymin = ys[-length(ys)],
                       ymax = ys[-1], alpha = alpha_steps)
trans_rect <- geom_rect(data = trans_df, fill = col_bg,
                        aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
                            alpha = alpha))
gg <- ggplot() +
  geom_rect(aes(xmin = 0, xmax = 1.5, ymin = 0, ymax = 1.5), fill = NA) +
  coord_fixed() +
  trans_rect + theme_void() + guides(alpha = FALSE) +
  annotation_custom(g_img, xmin = 0, ymin = -0.3)

## Sticker:
set.seed(123)
sticker(gg, package="POMA", p_size = 9.5, s_x = 0.966, s_y = .85, s_width = 1.27, 
        s_height = 1.48, p_color = col_text, h_fill = col_bg,
        spotlight = TRUE, l_x = 1.01, l_alpha = 0.2,
        h_color = col_border, filename="POMA_sticker.png",
        u_color = col_border, url = "polcastellano.shinyapps.io/POMA/")

