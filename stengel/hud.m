function hud( obj, event, string_arg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%fprintf('Running hud\n');

global  flightsys
x = flightsys.state(1:14); 
u = flightsys.state(15:end);
xm1 = flightsys.statem1(1:14);
h=figure(5); 
if (flightsys.hudfirst==1)
    set(h,'Toolbar','none');
set(h,'Resize','off');
flightsys.huddisp = gcf;
    set(gcf,'Color','w');
axis([-7 7 -7 5.5]);
end
if (flightsys.control.autopilot.SLAhold==1)
str = 'APM';
else 
    str = 'MAN';
end
set(h,'Selected','off');

% b = loadjson(urlread('http://caos-build.mit.edu:8000/once'));
% pitch = b.ac.ore.pitch;
% roll = b.ac.ore.roll;
% yaw = b.ac.ore.yaw;
% ll2xy(u(4),-roll,-pitch,yaw,...
%          x(9),flightsys.vkias*.5144,0,0,...
%          -x(6),0,...
%          0,0,b.curMode,...
%          0,0);

 ll2xy(u(1)+u(2)+u(3)+u(4),-x(10),-x(11),x(12),...
         x(9),flightsys.vkias*.5144,0,0,...
         -x(6),(xm1(6)-x(6))/flightsys.dt,...
         0,0,str,...
         0,0);
set(h,'Selected','on');
 
startlat = 19.0222;
startlon = -98.6278;
R_earth=6378137;

if (flightsys.hudfirst == 1)
    %load image
    %get boundary coordinates
    figure(1);flightsys.mapdisp = gca;
    image = imread('Popo_11_1.jpg');
    Popo = flipdim(image,1);
    [x, y, z] = size(Popo);
    map = flightsys.map;
    maxlat = map(1,2);minlat = map(1,3);
    maxlon = map(1,4);minlon = map(1,5);
    imagesc(minlon:((maxlon-minlon)/x):maxlon,minlat:((maxlat-minlat)/y):maxlat,Popo);
    axis('xy');
    %set start latitudes and longitudes
    flightsys.hudfirst =0;
    flightsys.lats(:,1) = startlon;
    flightsys.lats(:,2) = startlat;
    hold(flightsys.mapdisp,'on');
    flightsys.plts = plot(flightsys.lats(:,1),flightsys.lats(:,2),'y.','MarkerSize',12);
    hold(flightsys.mapdisp,'off');
end
%set zoomlevel and what is shown in frame

%change meters to lat/lon
    dn = flightsys.state(4);
    de = flightsys.state(5);
    dLat = dn/R_earth;
    dLon = de/(R_earth*cos(pi*dLat/180));
    newlat = startlat + dLat * 180/pi;
    newlon = startlon + dLon * 180/pi;
    flightsys.lats(1:end-1,:) = flightsys.lats(2:end,:);
    flightsys.lats(end,1) = newlon;flightsys.lats(end,2) = newlat;
    set(flightsys.plts,'XData',flightsys.lats(:,1),'YData',flightsys.lats(:,2),'MarkerSize',24);
    %plot(flightsys.mapdisp,newlon,newlat,'y.','MarkerSize',12)
    drawnow;
end
