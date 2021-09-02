function h=plotstates(varargin)
%PLOTSTATES plot state boundary lines on current axes.

% 
% Outputs: h - handle to line object drawn.
%

S=shaperead('US_States.shp');

x=[S.X]';
y=[S.Y]';

h=line(x,y,varargin{:},'Tag','states');

