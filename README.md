# advanced-ggplot2-gganimate
eco-data-sci workshop (January 2019) - advanced data viz in ggplot2 + gganimate

# Advanced Data Visualization (ggplot2)
eco-data-sci workshop (January 2019) 

[eco-data-sci.github.io](eco-data-sci.github.io)

<img src="https://github.com/allisonhorst/advanced-dataviz/blob/master/ggplot_draw.jpeg" width="500">

We'll use examples to explore some (slightly) advanced skills in ggplot2 with gganimate. 

Includes:

- Animated point plots
- Animated bubble plots
- Animated ridge plots (with ggridges)


## Required packages: 

- ggplot2
- ggridges 
- ggimage (optional, but fun...)
- gganimate

Install the last two (ggimage + gganimate) development versions from github:

```r
setRepositories(ind=1:2)
## install.packages("devtools")
devtools::install_github("GuangchuangYu/ggimage")
```

```r
# install.packages('devtools')
devtools::install_github('thomasp85/gganimate')
```

## Data: 
