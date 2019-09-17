function  SysID( obj, event, string_arg )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%fprintf('Running SysID\n');

global flightsys tmod
persistent rhs lhs

u = flightsys.statem1(13:end);
x = flightsys.statem1(1:12);
xdot = flightsys.dxdt;
alphar=flightsys.alphar;
betar=flightsys.betar; 
qbarS	=	flightsys.qbarS;
Thrust = flightsys.thrust; %%% This is identified "statically." 
mass = flightsys.mass ;%% this is identified before flight for now.
V = flightsys.V;
c = flightsys.chord;
	gb		=	flightsys.b2e * [0;0;9.80665];
%x(8)*4.231*c/(2*V)
	Ctemp	=	[ alphar alphar^2  u(1) 0      0     0     0;...
                  0      0         0    0      betar u(3) u(2);...
                  0      0         0    alphar 0     0    0];%  par = CLStatic,x,CLdEr,cdstat,CYBr,CYdRr,CYdAr;
  
         C=    [sin(alphar) 0 -cos(alphar);...
          0           1       0;...
          -cos(alphar) 0  -sin(alphar)]*Ctemp*qbarS/mass;
    
							
%	Dynamic Equations
	Xb = (xdot(1)- (gb(1) + x(9) * x(2) - x(8) * x(3)))-Thrust/mass-sin(alphar)*x(8)*4.231*c/(2*V)*qbarS/mass;
	Yb = (xdot(2)- (gb(2) - x(9) * x(1) + x(7) * x(3)));
	Zb = (xdot(3)- ( gb(3) + x(8) * x(1) - x(7) * x(2)))+cos(alphar)*x(8)*4.231*c/(2*V)*qbarS/mass;

    if (abs(alphar)<5/180*pi)
        lhs = [lhs;C];		
    rhs = [rhs;Xb;Yb;Zb];
    end
    length(rhs);
    if (length(rhs)>300)
    flightsys.coeff = (flightsys.coeff+rhs\lhs)/2;
    e = rhs-lhs*(flightsys.coeff)';
    sqrt(e'*e);
    rhs = rhs(151:300); lhs = lhs(151:300,:);
end
end

