
% produces a figure with sample colorbars using multigradient

rows = 8;

figure;

subplot(rows,1,1);
rgb = [1 0 0; 1 1 0; 0 1 0];
plot_bar(rgb, [], 'rgb');
title('Red-yellow-green');
xlabel({'multigradient([1 0 0; 1 1 0; 0 1 0])', ''});

subplot(rows,1,2);
rgb = [1 0 0; 1 1 0; 0 1 0];
pts = [1 2 5];
plot_bar(rgb, pts, 'rgb');
title('Red-yellow-green, skewed');
xlabel('multigradient([1 0 0; 1 1 0; 0 1 0], ''pts'', [1 2 5])');

subplot(rows,1,3);
rgb = [1 0 0; 1 1 1; 1 1 1; 0 1 0];
pts = [1 2 7 8];
plot_bar(rgb, pts, 'rgb');
title('Red-white-green, range-adjusted');
xlabel('multigradient([1 0 0; 1 1 1; 1 1 1; 0 1 0], ''pts'', [1 2 7 8])');

subplot(rows,1,4);
rgb = [0 0 0; 0 0 1; 0 0 1; 1 1 1; 0 0 1; 0 0 1; 0 0 0];
pts = [1 3 6 7 8 9 10];
plot_bar(rgb, pts, 'rgb');
title('Black-blue-black, white hotspot');
xlabel('multigradient([0 0 0; 0 0 1; 0 0 1; 1 1 1; 0 0 1; 0 0 1; 0 0 0], ''pts'', [1 3 6 7 8 9 10])');

subplot(rows,1,5);
rgb = [1 0 0; 0 0 1];
plot_bar(rgb, [], 'rgb');
title('Red-blue, RGB-interpolated');
xlabel('multigradient([1 0 0; 0 0 1])');

subplot(rows,1,6);
rgb = [1 0 0; 0 0 1];
plot_bar(rgb, [], 'hsv');
title('Red-blue, HSV-interpolated');
xlabel('multigradient([1 0 0; 0 0 1], ''interp'', ''hsv'')');

subplot(rows,1,7);
rgb = [1 0 0; 0 0 1];
plot_bar(rgb, [], 'hsv', 5);
title('Red-blue, HSV-interpolated, quantized');
xlabel('multigradient([1 0 0; 0 0 1], ''interp'', ''hsv'', ''length'', 5)');

subplot(rows,1,8);
rgb = [0 0 0; 1 0 0; 0 1 0; 0 0 0];
pts = [1 1.999 2 3];
plot_bar(rgb, pts, 'rgb');
title('Black-red-green-black, sharp edge');
xlabel('multigradient([0 0 0; 1 0 0; 0 1 0; 0 0 0], ''pts'', [1 1.999 2 3])');


function plot_bar(rgb, pts, interp, length)
if nargin == 3, length = 1000; end
imagesc(1:1000);
colormap(gca, multigradient(rgb, pts, 'length', length, 'interp', interp));
set(gca,'Yticklabel',[]);
set(gca,'Xticklabel',[]);
end
