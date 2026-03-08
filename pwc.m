function h=pwc(varargin)
axx=axis;
h=plotcoast('worldcoast','LineStyle','-','Linewidth',.5,'Color','b','HandleVisibility','off','Clipping','on',varargin{:});
if nargout==0
    clear h
end
axis(axx)