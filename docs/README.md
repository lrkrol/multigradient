# multigradient: an adjustable multiple-colour gradient colour map for MATLAB

This script allows you to generate a colour scale (as for colormap, colorbar) using any number of custom colours, and allows you to arrange these colours by adjusting their relative positions with respect to each other, much like you may be used to creating gradients in e.g. Adobe Photoshop or CorelDRAW. It will automatically interpolate the colours in between the indicated anchor points.

In its most basic form, simply call the script using an n-by-3 matrix of RGB values, and it will generate the colour map accordingly. For example, `multigradient([1 0 0; 1 1 0; 0 1 0])` will return a map that blends from red through yellow to green, of the same size as the current figure's color map. Further tricks are optional.

* Interpolation in __RGB__ space. Simple linear interpolation of the given RGB values.
* Interpolation in __HSV__ space. Linear interpolation of the values after conversion into HSV, for e.g. the rainbow colormap: `multigradient([1 0 0; 0 0 1], 'interp', 'hsv')`.
* Isoluminant interpolation in __L*a*b*__ space. The L* value is equalised for all given colours before linear interpolation and conversion back to RGB.
* Interpolation in Kenneth Moreland's __Msh__ space for divergent colour maps for scientific visualisation. A neutral unsatured middle point is automatically inserted if the two endpoint colours for the diverging map are sufficiently distinct. See [Moreland, K. (2009). Diverging color maps for scientific visualization. *In Proceedings of the 5th International Symposium on Visual Computing*. doi: 10.1007/978-3-642-10520-3_9](https://www.kennethmoreland.com/color-maps/ColorMapsExpanded.pdf).
* __Control points__ allow the relative distances between the colours to be adjusted.
* Many __presets__, including colour scales designed by [Kenneth Moreland](https://www.kennethmoreland.com) and [Cynthia Brewer](http://colorbrewer2.org), are included.

![Sample colour scales](./samples.png)

## Sample usage

`multigradient` itself returns a list of RGB values for colours. Starting with a figure ...

```
figure; imagesc(sort(rand(100), 'descend')); colorbar;`
```

we can change its color scale by calling `colormap` with that list as argument, or directly  with `multigradient` inline.

To create a simple black-red-yellow-white colormap, we would put those colours in that order as the first argument:

```
rgb = [0 0 0; 1 0 0; 1 1 0; 1 1 1];
colormap(multigradient(rgb));
```

It is possible to change the relative location of the colours by adjusting the relative values of the color stops, or control points. One control point must be indicated for each given colour. (Exception: when two colours are given, three control points can be used, with the second one representing the middle of the colour scale.)

``` 
pts = [1 5 6 7];
colormap(multigradient(rgb, pts));
```

Many presets are available. Kenneth Moreland suggests using the following diverging colour map for scientific visualisation:

```
colormap(multigradient('preset', 'div.km.BuRd'));
```

Look inside the script for other available presets.
