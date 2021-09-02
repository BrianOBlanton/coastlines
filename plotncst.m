function h=plotncst(varargin)


if length(varargin)<1
   error('PLOTNCST must have a color argument')
end


ncst=load('ncst.dat');
inan=find(isnan(ncst(:,1)));
for i=1:length(inan)-1
   i1=inan(i)+1;
   i2=inan(i+1)-1;
   h(i)=patch(ncst(i1:i2,1),ncst(i1:i2,2),varargin{1});
   if length(varargin)>1
      set(h(i),varargin{2:end});
   end
end

if nargout==0,clear h;,end
