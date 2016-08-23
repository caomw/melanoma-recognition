% File: http://web.mit.edu/8.13/matlab/Examples/xyerrorbars.m
% Date: 02-Nov-04
% Author: I. Chuang <ichuang@mit.edu>
%
% Demonstrate matlab plotting with vertical and horizontal error bars.
% Uses herrorbar() from www.mathworks.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
npts = 32;
xdat = linspace(0,2*pi,npts);
zdat = cos(xdat);
noise = (rand(1,npts)-0.5)/2;
ydat = zdat+noise;
errorbar(xdat,ydat,0.2*ones(1,npts),'ko');
hold on;
herrorbar(xdat,ydat,0.1*ones(1,npts),'ko');
plot(xdat,zdat,xdat,ydat,'go');
grid on;
title('Sample matlab file demonstrating vertical and horozintal error bars');