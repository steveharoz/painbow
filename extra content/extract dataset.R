# extract a dataset from the XKCD image

library("painbow")
library("png")
library("tidyverse")


#### get the image data

data_image = readPNG("extra content/dataset.png")
# convert to a data frame
data_image = reshape2::melt(data_image)
data_image = data_image %>% pivot_wider(names_from = Var3, values_from = value)
names(data_image) = c('x', 'y', 'r', 'g', 'b')
data_image = data_image %>% mutate( color = rgb(r, g, b) )

# scale color channels
data_image = data_image %>% mutate(
  r = r*255,
  g = g*255,
  b = b*255
)

# flip orientation
data_image = data_image %>% mutate(
  temp = x,
  x = y,
  y = -temp + max(temp) + 1) %>%
  select(-temp)


# check
ggplot(data_image) +
  aes(x, y, fill = color) +
  geom_raster() +
  scale_fill_identity() +
  theme_classic() +
  coord_equal()



#### generate lookup table for xkcd colors

# example use: interpolate_2_colors("#FFFFFF", "#000000", 0.5)
interpolate_2_colors = function(color1, color2, interpolation) {
  color = colorRamp(c(color1, color2))(interpolation)
  rgb(color[,1]/255, color[,2]/255, color[,3]/255)
}

# keep this high to make sure no values are skipped
interpolation_steps = 2

painbow_colors_lerped = tibble(color = painbow_colors) %>%
  mutate(next_color = lead(color)) %>%
  mutate(index = 1:n()) %>%
  group_by(color, next_color, index) %>%
  # for each row, add additional rows with an interpolation value
  expand(interpolation = seq(0, 1 - 1/interpolation_steps, length.out=interpolation_steps)) %>%
  rowwise() %>%
  mutate(interpolated_color = interpolate_2_colors(color, next_color, interpolation)) %>%
  ungroup() %>%
  # sort and give it a new index
  arrange(index, interpolation) %>%
  mutate(index = 1:n()) %>%
  pull(interpolated_color)

# convert colors to rgb [0-1]
painbow_colors_lerped =
  col2rgb(painbow_colors_lerped) %>%
  t() %>%
  as_tibble() %>%
  rowid_to_column("index") %>%
  mutate(hex = painbow_colors_lerped)

# de-duplicate for faster lookup
painbow_colors_lerped = painbow_colors_lerped %>%
  rowwise() %>%
  mutate(first_instance = which(painbow_colors_lerped$hex == hex)[1]) %>%
  mutate(spread = index - first_instance) %>%
  filter(spread == 0)




#### Convert the image to xkcd colormap index

# 3D distance
calculate_distance = function(x1, y1, z1, x2, y2, z2) {
  sqrt(
    (x1-x2)^2 +
    (y1-y2)^2 +
    (z1-z2)^2
  )
}

# find the closest color
# PARALLELIZED!!!
library(doParallel)
library(itertools)

# for each pixel, compare distance in colorspace with each painbow color
compute = function(data_chunk) {
  for (p in 1:nrow(data_chunk)) {
    if (p %% 100 == 0) print(round(100 * p/nrow(data_chunk), 2))

    pixel = data_chunk[p,]

    closest_distance = Inf
    closest_value = NA
    for (i in 1:nrow(painbow_colors_lerped)) {
      color = painbow_colors_lerped[i,]
      distance = calculate_distance(pixel$r, pixel$g, pixel$b, color$red, color$green, color$blue)
      if (distance < closest_distance) {
        closest_distance = distance
        closest_value = color$index
      }
    }
    data_chunk$value[p] = closest_value
  }
  return(data_chunk)
}

# Create a cluster with 1 fewer cores than are available. Adjust as necessary
mycluster = makeCluster(detectCores() - 1) # 16-1 cores
registerDoParallel(mycluster)
chunksize = ceiling(nrow(data_image)/getDoParWorkers())
# foreach
painbow_data = foreach(
        chunked_data=iter(data_image, by='row', chunksize=chunksize),
        .combine=rbind,
        .export=c('calculate_distance', 'painbow_colors_lerped', 'compute')
        ) %dopar% {
          compute(chunked_data)
        }
# stop
stopCluster(mycluster)

# scale values from 0 to 1
painbow_data = painbow_data %>% mutate(
  value = value / interpolation_steps / length(painbow_colors) * 120
)

# cleanup
painbow_data = painbow_data %>% select(x, y, value)

# test
ggplot(painbow_data) +
  aes(x, y, fill = value) +
  geom_raster(interpolate = TRUE) +
  scale_fill_painbow() +
  theme_classic()


# #### expand the dataset for smoother rendering
#
# # smooth a dataset for prettier graphs
# # data must have x, y, and value
# interpolate_dataset = function(data, scale=10) {
#   # set up the indices and interpolation levels for lookup
#   expanded = expand.grid(
#     x = (1:(max(data$x) * scale)) / scale,
#     y = (1:(max(data$y) * scale)) / scale) %>%
#     mutate(
#       x_prop = x %% 1.0,
#       y_prop = y %% 1.0,
#       x1 = floor(x) + 1,
#       y1 = floor(y) + 1,
#       x2 = ceiling(x+0.001) + 1,
#       y2 = ceiling(y+0.001) + 1
#     ) %>%
#     filter(x2 <= max(data$x), y2 <= max(data$y))
#
#   # make the original data a nicely indexable matrix
#   painbow_matrix = data %>% arrange(y, x) %>% pivot_wider(id_cols = x, names_from = y) %>% select(-x) %>% as.matrix()
#
#   # 2D lerp
#   lerp2D = function(d) {
#     #print(d)
#         v11 = painbow_matrix[d$x1, d$y1]
#         v12 = painbow_matrix[d$x1, d$y2]
#         v21 = painbow_matrix[d$x2, d$y1]
#         v22 = painbow_matrix[d$x2, d$y2]
#         lo = v11 * (1-d$x_prop) + v21 * d$x_prop
#         hi = v12 * (1-d$x_prop) + v22 * d$x_prop
#         return(lo * (1-d$y_prop) + hi * d$y_prop)
#       }
#
#   # lookup based on the indices and interpolate the values
#   expanded = expanded %>%
#     rowwise() %>%
#     mutate( value = lerp2D(cur_data()) ) %>%
#     ungroup()
#
#   # cleanup
#   expanded = expanded %>% select(x, y, value)
#
#   return(expanded)
# }
#
# # test
# painbow_data = painbow_data %>% interpolate_dataset(scale = 10)
# ggplot(temp) +
#   aes(x, y, fill = value) +
#   geom_raster() +
#   scale_fill_painbow() +
#   theme_classic()

usethis::use_data(painbow_data, overwrite = TRUE)
