addpath('C:\Users\mitre\OneDrive\Documents\CICESE\Tecnico\programas\matlab')
trayec_mit
close all; clear; clc

lista1='C:\Users\mitre\OneDrive\Documents\CICESE\DC_TESIS\Corridas_iniciales\E0_canyon\Padre_interno_editable\gebco_2023_n35.8096_s26.7938_w-121.9038_e-113.2938.nc';
z=nc_varget(lista1,'elevation');
x=nc_varget(lista1,'lon');
y=nc_varget(lista1,'lat');

p01=[-116.6,31.80];      % punto TBS 

%% Figure without edition
figure; set(gcf,'Position',[50 50 500 700]);  hold on; set(gca,'box','on'); 
% m_proj('oblique','lon',[min(x) max(x)],'lat',[min(y) max(y)],'aspect',.8);
m_proj('lambert','lon',[min(x) max(x)],'lat',[min(y) max(y)]);
          
s = m_pcolor(x,y,z); set(s, 'edgecolor', 'none'); shading interp; 
m_contour(x,y,z,[-2000,-1750-1500,-1250,-1000,-900,-800,-700,-600,-500,-400,-300,-200, -100, -50, -20], 'edgecolor',[0.1 0.1 0.1]);
m_gshhs_f('patch',[0.2 0.4 0.2]);   
m_contour(x,y,z,[0.0, 0.0], 'edgecolor', 'k', 'linewidth', 1.3)
m_plot(p01(1),p01(2),'.','markersize',18,'color','r')
m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);
      
% cd C:\Users\mitre\OneDrive\Documents\CICESE\DC_TESIS\Corridas_iniciales\E0_canyon\figuras
% export_fig('mapa_padre','-jpg', '-m2', '-ZBuffer','-transparent' );

%% Cut the Guf
f1=find(x>-116.5); g1=find(y>32);  z(g1,f1)=1000;
f2=find(x>-115); g2=find(y>30);   z(g2,f2)=1000;
f3=find(x>-114.6); g3=find(y>29);   z(g3,f3)=1000;
f4=find(x>-113.8); g4=find(y>28.64);   z(g4,f4)=1000;

%% Figure with edition
figure; set(gcf,'Position',[50 50 500 700]);  hold on; set(gca,'box','on'); 
% m_proj('oblique','lon',[min(x) max(x)],'lat',[min(y) max(y)],'aspect',.8);
m_proj('lambert','lon',[min(x) max(x)],'lat',[min(y) max(y)]);
          
s = m_pcolor(x,y,z); set(s, 'edgecolor', 'none'); shading interp; 
m_contour(x,y,z,[-2000,-1750-1500,-1250,-1000,-900,-800,-700,-600,-500,-400,-300,-200, -100, -50, -20], 'edgecolor',[0.1 0.1 0.1]);
% m_gshhs_f('patch',[0.2 0.4 0.2]);    
caxis([-7000 7000])
m_contour(x,y,z,[0.0, 0.0], 'edgecolor', 'k', 'linewidth', 1.3)
m_plot(p01(1),p01(2),'.','markersize',18,'color','r')
m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);
disp(size(x))
disp(size(y))
disp(size(z))

%% create the new file (Save only for latitude and longitude)
ncnc=netcdf.create(['padre_01','.nc'] ,'NC_WRITE');  

lonID=netcdf.defDim(ncnc,'x', length(x));
vlongID=netcdf.defVar(ncnc,'x','double',lonID);
netcdf.putAtt(ncnc,vlongID,'units','degrees');

latID=netcdf.defDim(ncnc,'y', length(y));
vlatID=netcdf.defVar(ncnc,'y','double',latID);
netcdf.putAtt(ncnc,vlatID,'units','degrees');

netcdf.endDef(ncnc)

%% start put data  
netcdf.putVar(ncnc,vlatID,y);
netcdf.putVar(ncnc,vlongID,x);
netcdf.close(ncnc)

%% (Save only for depth)
depth=z;
% nccreate("padre_01.nc","depth", ...
%          "Dimensions",{"latitude",2163,"longitude",2066},"Format","netcdf4_classic")
ncwrite("padre_01.nc","depth",depth);

z1 = ncread("padre_01.nc","depth");
x1 = ncread("padre_01.nc","x");
y1 = ncread("padre_01.nc","y");

%% Figure with edition from the new netcdf
figure; set(gcf,'Position',[50 50 500 700]);  hold on; set(gca,'box','on'); 
m_proj('lambert','lon',[min(x1) max(x1)],'lat',[min(y1) max(y1)]);
          
s = m_pcolor(x1,y1,z1); set(s, 'edgecolor', 'none'); shading interp; 
m_contour(x1,y1,z1,[-2000,-1750-1500,-1250,-1000,-900,-800,-700,-600,-500,-400,-300,-200, -100, -50, -20], 'edgecolor',[0.1 0.1 0.1]);   
caxis([-7000 7000])
m_contour(x1,y1,z1,[0.0, 0.0], 'edgecolor', 'k', 'linewidth', 1.3)
m_plot(p01(1),p01(2),'.','markersize',18,'color','r')
m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);
