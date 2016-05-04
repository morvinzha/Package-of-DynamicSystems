# Package of Dynamic Systems
This Package is a toolbox for Analyzing Dynamic Systems.

## Introduction of .jl files
Plotting : ``DynamicSystemPlot.jl`` is for visualization of a 2-D dynamic system, based on ["Gadfly"](http://dcjones.github.io/Gadfly.jl/index.html)

## Usage
### Plotting
All args of ```DynamicSystemPlot``` function are:
```
Dyn::DynamicSystem
Npoint=100                # How many points do you want to plot in each path?
Npath=20                  # How many path do you want to plot in this graph?
resol=0.01                # How "long"(time step) is each point to the next point.
width=0.05                # How wide is the initial point of each path to the next one  
Op="s"                    # Another option is  Op == "PNG", to creat a .PNG file of this graph.
```
