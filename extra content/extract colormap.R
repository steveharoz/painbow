# extract a colormap from an image that is 1 pixel wide

library("png")

#get the image and its size
colormap_image = readPNG("extra content/colormap image.png")
pixel_count = dim(colormap_image)[1] # image height

# convert the pixel values into rgb hex strings
colormap_colors = sapply(1:pixel_count, function(i) {
  rgb(
    colormap_image[i, 1, 1],
    colormap_image[i, 1, 2],
    colormap_image[i, 1, 3])
})
# it's backwards
colormap_colors = rev(colormap_colors)
values = seq(0, 1, length.out = length(colormap_colors))

# code to call in R
paste(
  "c(",
  paste(
    paste0("'", colormap_colors, "'"),
    collapse = ", "
  ),
  ")"
)

