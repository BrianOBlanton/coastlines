function h=drawgshhg(varargin)
% 
% drawgshhg - draw gshhs lines
% Global Self-Consistent Hierarchical High-Resolution Geography
% https://www.mathworks.com/help/map/ref/gshhs.html
%
% Input: 
%   Region     - 'world' (def), 'northatlantic' | 'na', 'northcarolina' | 'nc'
%   ShiftLon   - shift lons to west < 0 (def=False)
%   Resolution - {'c','l','i','h','f'}  def='c'
%                 crude(c), low(l), intermediate(i), high(h), and full(f)
%   Limits     - 4x1 vector, [minlo maxlo minla maxla]
%                or the string "axis" in which case the current axes limits
%                will be used to extract data from the GSHHS files
%   Field      - name of GSHHG variable to load/plot, def='gshhs'
%               'gshhs','binned_GSHHS','binned_border','binned_river','wdb_borders','wdb_rivers'
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
resolutions={'c','f','h','l','i'};
regions=["world","na","nc","ep"];
lims={[-180  180  -90  90], [-120    0    0  70], [-80   -70   30  40], [-200 -100    0  70]};
regiondict=dictionary(regions,lims);

% set defs 
region=regions{1};
res=resolutions{1};
lim=lims{1}; 
field=fields{1};
% landonly=true;

% Strip off propertyname/value pairs in varargin not related to
% "line" object properties.
if length(varargin)/2 ~= floor(length(varargin)/2)
    error('length of varargin odd.  Something is missing.')
end

k=1;
while k<length(varargin)
    switch lower(varargin{k})
        case 'region'
            region=varargin{k+1};
            varargin([k k+1])=[];
            if ~ismember(region,regions)
                % error("region not found in regions list: %s",regions)
                error("region not found in regions list.")
            end
        case {'lims', 'limits'}
            lim=varargin{k+1};
            varargin([k k+1])=[];
            if isstr(lim)
                if ~strcmp(lim,'axis')
                    error('lims argument must be the string "axis" of a 1x4 vector.')
                end
            elseif numel(lim)~=4
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
            if ~ismember(field,field)
                error("field not found in list.")
            end
        otherwise
            k=k+2;
    end
end

if strcmp(lim,'axis')
    lim=axis;
elseif ~strcmp(region,'world')
    lim=regiondict{region};
end

S = gshhs(sprintf('%s/%s_%s.b',GSHHGDIR,field,res),lim([3 4]),lim([1 2]));

levels = [S.Level];
land = (levels == 1);
S=S(land);

lo= [S.Lon];
la= [S.Lat];

if ~ismap(gca) 
    h=line(lo, la,'Color','k',varargin{:});
else
    hold on
    h=geoshow(la,lo,"DisplayType","line",varargin{:});
    hold off
end

