\name{scale_colour_painbow}
\alias{scale_color_painbow}
\alias{scale_colour_painbow}
\alias{scale_fill_painbow}

\title{Painbow colormap}

\description{Use XKCD's "Painbow" colormap}

\usage{
scale_color_painbow(...)
scale_colour_painbow(...)
scale_fill_painbow(...)
}

\arguments{
  \item{...}{ Any arguments are passed to \code{\link[ggplot2:scale_fill_gradientn]{ggplot2:scale_fill_gradientn()}} }
}

\details{The colors were extracted directly from the colorscale in XKCD's image (https://xkcd.com/2537/).}

\author{Steve Haroz}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
See \code{\link[ggplot2:scale_fill_gradientn]{ggplot2:scale_fill_gradientn()}} for additional arguments.
}

\examples{
# You can use it for continuous data
library(ggplot2)
ggplot(faithfuld) +
  aes(waiting, eruptions, fill = density) +
  geom_tile() +
  scale_fill_painbow()
}
