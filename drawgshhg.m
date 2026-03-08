function [h,S]=drawgshhg(varargin)
% 
% drawgshhg - draw gshhs lines
% Global Self-Consistent Hierarchical High-Resolution Geography
% https://www.mathworks.com/help/map/ref/gshhs.html
%
% Input: 
%   Region - 'world' (def), 'northatlantic' | 'na', 'northcarolina' | 'nc'
%   ShiftLon - shift lons to 0-360 (def=False)
%   Resolution - {'c','l','i','h','f'}  def='c'
%       Full resolution = 0.04 km  
%       High resolution = 0.2 km
%       Intermediate resolution = 1.0 km
%       Low resolution = 5.0 km
%       Crude resolution = 25  km      
%   Limits - 4x1 vector, [minlo maxlo minla maxla]
%   Field - name of GSHHG variable to load/plot, def='gshhs'
%          'gshhs','binned_GSHHS','binned_border','binned_river','wdb_borders','wdb_rivers'}
% 
% E.g.,
%
% h=drawgshhg('Region','nc','resolution','l','Color','b')
%

GSHHGDIR='/Users/bblanton/matlab/data.matlab/GSHHG';
if ~exist(GSHHGDIR,'dir')
    error('Could not find GSSHG dir: %s',GSHHGDIR)
end

fields={'gshhs','binned_GSHHS','binned_border','binned_river','wdb_borders','wdb_rivers'};
resolutions={'c','l','i','h','f'};
regions=["world","na","nc","ep"];
%lims={double.empty(4,0), [-120    0    0  70], [-80   -70   30  40], [-200 -100    0  70]};
lims={[-180  180  -90  90], [-120    0    0  70], [-80   -70   30  40], [-200 -100    0  70]};
regiondict=dictionary(regions,lims);

% set defs 
region=regions{1};
res=resolutions{1};
lim=lims{1}; 
field=fields{1};
shiftlon=false;

% Strip off propertyname/value pairs in varargin not related to
% "line" object properties.
if length(varargin)/2 ~= floor(length(varargin)/2)
    error('length of varargin is odd.  Something is missing.')
end

k=1;
while k<length(varargin)
    switch lower(varargin{k})
        case 'region'
            region=varargin{k+1};
            varargin([k k+1])=[];
            if ~ismember(region,regions)
                %          error("region not found in regions list: %s",regions)
                error("region not found in regions list.")
            end
        case {'lims', 'limits'}
            lim=varargin{k+1};
            varargin([k k+1])=[];
            if numel(lim)~=4
                error('limits vector not 1x4 | 4x1.')
            end
        case {'res','resolution'}
            res=varargin{k+1};
            varargin([k k+1])=[];
            if ~ismember(res,resolutions)
                error("resolution not found in list.")
            end
        case {'field'}
            field=varargin{k+1};
            varargin([k k+1])=[];
            if ~ismember(field,fields)
                error("field not found in list.")
            end
        case {'shiftlon'}
            shiftlon=varargin{k+1};
            varargin([k k+1])=[];
            if ~islogical(shiftlon)
                error("shiftlon must be true | false.")
            end
        otherwise
            k=k+2;
    end
end

if ~strcmp(region,'world')
    lim=regiondict{region};
end

S = gshhs(sprintf('%s/%s_%s.b',GSHHGDIR,field,res),lim([3 4]),lim([1 2]));

if shiftlon
    for i=1:length(S)
        if all(S(i).Lon>180)
            S(i).Lon=S(i).Lon-360;
        end
    end

end


lo= [S.Lon];
la= [S.Lat];

% if ismap(gca)
%     mstruct=gcm;
%     [lo,la] = projfwd(mstruct,la,lo);
% end
% 
% h=line(lo, la,'Color','k',varargin{:});
% h.Clipping='on';

% return

if ~ismap(gca) 
    h=line(lo, la,'Color','k',varargin{:});
else
    hold on
    h=geoshow(la,lo,"DisplayType","line",varargin{:});
    hold off
end



