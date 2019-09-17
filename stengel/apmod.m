function apmod( obj, event, string_arg )
%% Map handheld input.
global flightsys
%fprintf('Running apmod\n');
x = flightsys.state(1:14);
u = flightsys.state(15:end);
du = zeros(size(u));
joyinp = axis(flightsys.input.joy,1:4);
%for hover:
statThrust=8100;
thr = (1-joyinp(3))*statThrust;
tvec = zeros(2,2);
tvec(:,1) = joyinp(1);
tvec(:,2) = -joyinp(1);
tvec(1,:) = tvec(1,:) + joyinp(2);
tvec(2,:) = tvec(2,:) - joyinp(2);
tvec([1 4])= tvec([1 4]) +joyinp(4);
tvec([2 3])= tvec([2 3]) - joyinp(4);
thr4 = thr+tvec*thr*0.1;
u(1)= thr4(1,1);
u(2)= thr4(1,2);
u(3)= thr4(2,2);
u(4)= thr4(2,1);


%% Read User input from joystick.
butinp = button(flightsys.input.joy);

%% Hover to Level Transition and Level to Hover Transition
%  if butinp(6) 
% %     %   press this button, switch to hover from foward or foward from hover,
% %     %   transition for five seconds and then dynamics switch to hover or
% %     %   forward
%     flightsys.mode= 1- flightsys.mode;
%     x(13)= pi/2- x(13);
%     t=flightsys.dt;
%      while t< 5
%          flightsys.transition=1;
%           t= t+ flightsys.dt;
%      end
%  end
%% Autopilot Trigger: straight-level flight condition.
% if (butinp(1)&& ~flightsys.input.bLastTriggerVal)
%     flightsys.control.autopilot.SLAhold=1-flightsys.control.autopilot.SLAhold;
% end
% flightsys.input.bLastTriggerVal = butinp(1);
% %% Autopilot
% if (flightsys.control.autopilot.SLAhold)
% ve = flightsys.b2e'*[x(1);x(2);x(3)]
% alt = -x(6);
% slewrate = 0.3;
% %Pitch Control
% %     du(1)=min(max((x(11)+x(8) ... %Straight
% %     -(flightsys.vkias-180)/200 ...
% %     +(alt-2500)/1000),-slewrate),slewrate); %% straight
% %     du(2)= -(rem(x(12),2*pi)-pi/5)/pi-0.5*rem(x(10),2*pi)-0.5*x(7); %% wings level
% %     du(3) = x(9)+randn/100; %No yaw rate
%     du(4)=-min(max((alt-2500)/200-ve(3)/30+(flightsys.vkias-180)/500,-slewrate),slewrate); %%Throttle controls altitude
%     du(1)=-min(max((alt-2500)/200-ve(3)/30+(flightsys.vkias-180)/500,-slewrate),slewrate);
%     du(2)=-min(max((alt-2500)/200-ve(3)/30+(flightsys.vkias-180)/500,-slewrate),slewrate); %%Throttle controls altitude
%     du(3)=-min(max((alt-2500)/200-ve(3)/30+(flightsys.vkias-180)/500,-slewrate),slewrate);
% % Control Saturation
% end
%% Update
u = u+du;
flightsys.thrust=int16(thr4);
flightsys.state(15:end) = u;
