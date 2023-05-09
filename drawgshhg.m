function h=drawgshhg(varargin)
% drawgshhg - draw coastlines from pre-computed subsets of GSHHG
% 
% Speficy the region with 'Region',<region>.
%
% Available regions.
%   'world'
%   'northatlantic','na'
%   'northcarolina','nc'
%
%   h=drawgshhg(varargin)
%       Region


global Constants

GSHHGDIR='/Users/bblanton/matlab/data.matlab/GSHHG';

% %h=geoshow([shorelines2.Lat], [shorelines2.Lon],'Color','k','LineWidth',2);
% h=line([shorelines.Lat], [shorelines.Lon],'Color','k','LineWidth',2,varargin{:});

region='northatlantic';

% Strip off propertyname/value pairs in varargin not related to
% "line" object properties.
k=1;
while k<length(varargin)
  switch lower(varargin{k})
    case 'region'
      region=varargin{k+1};
      varargin([k k+1])=[];
    otherwise
      k=k+2;
  end
end     

switch lower(region)
    case {'world'}
        if exist('Constants','var') && ...
                isfield(Constants,'shorelines') && ...
                isfield(Constants.shorelines,'world')
            temp=load([GSHHGDIR '/world.mat']);
        end
    case {'northatlantic','na'}
        temp=load([GSHHGDIR '/northAtlantic.mat']);
    case {'northcarolina','nc'}
        temp=load([GSHHGDIR '/northCarolina.mat']);
    otherwise
        error('Invalid region.')
end

lo=temp.lon';
la=temp.lat';

h=line(lo, la,'Color','k',varargin{:});
