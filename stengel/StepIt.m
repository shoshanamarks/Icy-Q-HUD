function StepIt( obj, event, string_arg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fprintf('Running Stepit\n');

global flightsys

if (flightsys.state(6)>0)
    delete(obj);
    disp('Touch down or Crash, Simulation ends');
    return
end
% Dynamics
 tm = clock;
 flightsys.dt=min(etime(tm,flightsys.time),.025);
 flightsys.time = tm;
 if (flightsys.count ==0) %% Just use Euler
    dx = flightsys.dt*IcyQDynamics(flightsys.dt,flightsys.state);
    disp('Euler')
 else
     dx = flightsys.dt*(3/2*IcyQDynamics(flightsys.dt,flightsys.state)-1/2*IcyQDynamics(flightsys.dt,flightsys.statem1));
     disp('fly')
 end
    flightsys.statem2 = flightsys.statem1;
    flightsys.statem1 = flightsys.state;
    flightsys.count = flightsys.count+1;
    flightsys.state=flightsys.state+dx';
    flightsys.dxdt=dx'/flightsys.dt;   
end

