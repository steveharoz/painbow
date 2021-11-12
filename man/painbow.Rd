\name{painbow}

\alias{painbow.colors}
\alias{scale_color_painbow}
\alias{scale_colour_painbow}
\alias{scale_fill_painbow}

\title{XKCD Painbow Colormap}

\description{Use XKCD's "Painbow" colormap in base and ggplot2 graphics.}

\usage{
painbow.colors(n, alpha = FALSE, rev = FALSE)

scale_color_painbow(...)
scale_colour_painbow(...)
scale_fill_painbow(...)
}

\arguments{
  \item{n}{integer. The number of colors (\eqn{\ge 1}) in the palette.}
  \item{alpha}{logical or numeric. Specification of an alpha-transparency (vector)
    in the range from 0 (transparent) to 1 (opaque). If \code{FALSE} no alpha
    level is added. If \code{TRUE} full opacity (1) is used for all colors.}
  \item{rev}{logical. Should the ordering of the colors be reversed?}
  \item{...}{ Any arguments are passed to \code{\link[ggplot2:scale_fill_gradientn]{ggplot2:scale_fill_gradientn()}} }
}

\details{
  The 192 colors in the palette were extracted directly from the colormap in XKCD's image
  (\url{https://xkcd.com/2537/}).

  The \code{palette.colors} function extracts \code{n} colors along the 192 colors
  by linear interpolation of the underlying RGB (red-green-blue) coordinates.
  
  The \code{scale_*_painbow} functions provide scales for ggplot2 graphics.
}

\author{Steve Haroz}

\seealso{
See \code{\link[ggplot2:scale_fill_gradientn]{ggplot2:scale_fill_gradientn()}} for additional arguments.
}

\examples{
## recreate painbow heatmap for continuous data
data("painbow_data", package = "painbow")

## ggplot2 graphics
library("ggplot2")
ggplot(painbow_data) +
  aes(x, y, fill = value) +
  geom_tile() +
  scale_fill_painbow()

## base graphics
pd <- matrix(painbow_data$value, ncol = 205, byrow = TRUE)[, 205:1]
filled.contour(pd, color.palette = painbow.colors)
filled.contour(pd, color.palette = painbow.colors, nlevels = 100)

# Old Faithful data
data("faithfuld", package = "ggplot2")
ggplot(faithfuld) +
  aes(waiting, eruptions, fill = density) +
  geom_tile() +
  scale_fill_painbow()

## illustrate usage of base palette
painbow.colors(5)                ## original order
painbow.colors(5, rev = TRUE)    ## reversed order
painbow.colors(5, alpha = TRUE)  ## with explicit full opacity
painbow.colors(5, alpha = 0:4/4) ## with decreasing transparency
}
