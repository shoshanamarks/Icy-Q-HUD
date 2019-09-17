function Graphics( obj, event, string_arg )

global  flightsys
state = flightsys.state;
figure(1);
%   subplot(212); plot(state(4),state(5),'bx');
 %      axis([-5000 5000 -5000 5000]);

  % subplot(211); plot(state(4),-state(6),'bx');
   %axis([-5000 5000  -500 5000]);
    %hold on;
    clf;
    text(0.1,0.5,sprintf('Position: %f,%f,%f',state(4),state(5),-state(6)));
    text(0.1,0.1,sprintf('Roll, Pitch, Yaw: %f,%f,%f',state(10)/pi*180,state(11)/pi*180,state(12)/pi*180));
axis('off');


end

