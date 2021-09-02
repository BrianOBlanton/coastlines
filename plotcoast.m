function h=plotcoast(varargin)
%PLOTCOAST plot geographic lines on current axes.
% PLOTCOAST loads and plots coastlines, political boundaries, etc.
% on the current axes.  The geographic files available are located in
% the "coastlines" directory, with the extension dat.  
%
%  Inputs: cflag - coastline file to load/plot  (optional)
%                  If no coastline filename is given, PLOTCOAST
%                  uses the name last passed to PLOTCOAST.
%          PLOTCOAST passes all other arguments to LINE.
%          Pass PLOTCOAST "help" for a list of files and locations.
%          Pass PLOTCOAST "demo" for map of all possible choices.
% 
% Outputs: h - handle to line object drawn.
%
% Available coasts:
%     'americas_coarse'    
%     'coarse_us_coast'    
%     'east_us_wvs'        
%     'gomex_wdbII'        
%     'gomex_wvs'          
%     'internal_wdbII'     
%     'international_wdbII'
%     'noaa' 
%     'northAtlantic'      
%     'northCarolina'      
%     'rivers'             
%     'states'             
%     'wdbII_pol_bndy'     
%     'west_us_noaa'       
%     'west_us_wvs'        
%     'worldcoast'         
%     'worldgshhg'         
%     'wvslpl'               

global PLOTCOAST

if isfield(PLOTCOAST,'dir')
   coastdir=PLOTCOAST.dir;
else
   coastdir='';
end

files=dir([coastdir '/*.cldat']);
if isempty(files)
   fprintf(['No .cldat files in dir ' coastdir ' to plot. Seek professional help.\n'])
   return
end

for i=1:length(files)
    [~,cases{i},~]=fileparts(files(i).name);
end

% force worldcoast to be first in list
idx=find(strcmp(cases,'worldcoast'));
cases={cases{idx},cases{setdiff(1:length(cases),idx)}};

cflag=[];
if rem(nargin,2)==1   % odd

   cflag=varargin{1};
    
   switch cflag
      case 'help'
         str=sprintf('\nCall as: \n');
         str=[str sprintf('   plotcoast(cflag,p1,v1,p2,v2,...) \n')];
         str=[str sprintf('\nCoastline files are in:\n')];
         str=[str sprintf('   %s\n',coastdir)];
         str=[str sprintf('\nUser-defined coastline files are in:\n')];
         str=[str sprintf('   %s\n',PLOTCOAST.userdir)];
         str=[str sprintf('\n%s\n','Possible choices are:')];
         for i=1:length(cases)
            str=[str sprintf('   %s\n',cases{i})];
         end
         disp(str)
         return
      case 'demo'
% old demo code
%          co={'r','g','b','k','m','c'};
%          hd=[];
%          for i=1:length(cases)
%              hd(i)=plotcoast(cases{i},'Color',co{rem(i,length(co))+1});
%              axeq;
%              legend(hd,strrep(cases,'_','\_'),3)
%              drawnow
%          end
%          axis([-180 -30 0 90])
% new demo code:
          fullpage         
          for i=1:length(cases)
             subplot(length(cases)/2,2,i)
             plotcoast(cases{i});
             axis('equal')
             title(strrep(cases{i},'_','\_'),'FontSize',14)
          end
 
          suptitle('PLOTCOAST Options','FontSize',17)
          return
      otherwise
         varargin(1)=[];
   end
end

if isempty(cflag)
    cflag='americas_coarse';
end
% %     if ~isfield(PLOTCOAST,'COAST') || isempty(PLOTCOAST.COAST)
% %        disp(' ')    
% %        disp('No coast argument to PLOTCOAST and no previous coast set.')    
% %        disp('Please speficy coast argument to PLOTCOAST.')
% %        plotcoast('help')
% %        return
% %    end
% %    if isempty(PLOTCOAST.COAST)
% %       disp('No coast argument to PLOTCOAST and no previous coast set.')    
% %       disp('Please speficy coast argument to PLOTCOAST.')
% %       return
% %    end
%     % get coast and data from global PLOTCOAST
% %   disp('Getting coast and data from global PLOTCOAST...')
%    d=load([coastdir '/' cflag '.cldat']);
%    PLOTCOAST.COAST=cflag;
%    PLOTCOAST.d=d;  
%    lo=PLOTCOAST.d(:,1); 
%    la=PLOTCOAST.d(:,2); 
%    if isempty(varargin)
%       if ~isfield(PLOTCOAST,'plotargs')
%          plotargs={};
%       else
%          plotargs=PLOTCOAST.plotargs;
%       end
%    else
%       plotargs=varargin;
%       PLOTCOAST.plotargs=varargin;
%    end
% 
% else
   switch cflag 
      case cases
%         disp(['Loading ' cflag ' ...']);
         d=load([coastdir '/' cflag '.cldat']);
      otherwise
         error('Unknown cflag to PLOTCOAST')
   end
   PLOTCOAST.COAST=cflag;
   PLOTCOAST.d=d;  
   if ~isempty(varargin)
      PLOTCOAST.plotargs=varargin;
      plotargs=varargin;
   else
      PLOTCOAST.plotargs={};
   end
   lo=PLOTCOAST.d(:,1); 
   la=PLOTCOAST.d(:,2); 
   plotargs=PLOTCOAST.plotargs;
% end

xax=get(gca,'xlim');
yax=get(gca,'ylim');

%disp(['Drawing ' cflag ' ...']);
%h=line(PLOTCOAST.d(:,1),PLOTCOAST.d(:,2),PLOTCOAST.plotargs{:});
h=line(lo,la,plotargs{:},'Tag','coastline');

if nargout==0,clear h, end

