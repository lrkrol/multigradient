% map = multigradient(rgb, pts[, varargin])
%
%       Returns a custom colormap generated from the indicated colors
%       anchored at the indicated points (color stops), with their relative
%       positions intact, and gradients between them.
%
% In:
%       rgb - n-by-3 matrix of rgb color values
%       pts - vector of length n indicating the relative positions of
%             the color points in colorrgb 
%
% Optional:
%       interp - which color representation to use for interpolation 
%                ('hsv' or 'rgb', default: 'rgb')
%       length - the length of the colormap. default: length of the current
%                figure's colormap
%
% Out:
%       map - the generated colormap
%
% Usage example:
%       A simple red-yellow-green colormap would be:
%       >> rgb = [.9 0 0; .9 .9 0; 0 .8 0];
%       >> pts = [1 2 3];
%       >> figure; imagesc(sort(rand(100), 'descend')); colorbar;
%       >> colormap(multigradient(rgb, pts));
%
%       It is possible to e.g. change the location of the yellow point, by
%       adjusting the range and/or relative values of the color stops:
%       >> rgb = [.9 0 0; .9 .9 0; 0 .8 0];
%       >> pts = [1 4 5];
%
%       Similarly, the width of the yellow band can be changed by repeating
%       the yellow color (i.e., making a red-yellow-yellow-green map):
%       >> rgb = [.9 0 0; .9 .9 0; .9 .9 0; 0 .8 0];
%       >> pts = [1 2 3 4];
%
%       Other examples:
%       >> imagesc(sort(rand(100)));
%       >> colormap(multigradient(repmat([0 .35 1]', 1, 3), [0 3 4]));
% 
%       >> figure; surfc(peaks(250), 'EdgeColor', 'none'); colorbar;
%       >> colormap(multigradient([.1 .1 .3; .2 .3 .7; .6 .6 .1; 0 .5 0; .9 .9 .9], [0 1.05 1.25 1.35 3], 'length', 250));
%
%                       Copyright 2018 Laurens R Krol
%                       lrkrol.com

% 2018-07-14 First version

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function map = multigradient(rgb, pts, varargin)

p = inputParser;

addRequired(p, 'rgb', @(rgb) (isnumeric(rgb) && size(rgb,2) == 3));
addRequired(p, 'pts', @(pts) (isnumeric(pts) && numel(pts) == size(rgb,1)));

addParameter(p, 'interp', 'rgb', @(interp) any(validatestring(interp,{'rgb', 'hsv'})));
addParameter(p, 'length', [], @isnumeric);

parse(p, rgb, pts, varargin{:});

rgb = p.Results.rgb;
pts = p.Results.pts;
interp = p.Results.interp;
length = p.Results.length;

if isempty(length)
    length = size(get(gcf,'colormap'),1);
end

pts = maptorange_local(pts, [min(pts), max(pts)], [1, length]);

if strcmp(interp, 'hsv')
    maphsv = interp1(pts, rgb2hsv(rgb), 1:length);
    map = hsv2rgb(maphsv);
elseif strcmp(interp, 'rgb')
    map = interp1(pts, rgb, 1:length);
end

end


function targetvalue = maptorange_local(sourcevalue, sourcerange, targetrange, varargin)

% limited local version of maptorange;
% see github.com/lrkrol/maptorange for full functionality

if numel(sourcevalue) > 1
    % recursively calling this function
    for i = 1:length(sourcevalue)
        sourcevalue(i) = maptorange_local(sourcevalue(i), sourcerange, targetrange, varargin{:});
        targetvalue = sourcevalue;
    end
else
    % converting source value into a percentage
    sourcespan = sourcerange(2) - sourcerange(1);
    if sourcespan == 0, error('Zero-length source range'); end
    valuescaled = (sourcevalue - sourcerange(1)) / sourcespan;

    % taking given percentage of target range as target value
    targetspan = targetrange(2) - targetrange(1);
    targetvalue = targetrange(1) + (valuescaled * targetspan);
end

end