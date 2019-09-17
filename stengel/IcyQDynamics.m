function xdot = IcyQDynamics(t,x)
global flightsys
X= x(4);
Y= x(5);
Z = x(6);
U= x(1);
V = x(2);
W= x(3); 
phi = x(10);
theta = x(11);
psi = x(12);
P= x(7);
Q= x(8);
R= x(9);
beta= x(13);
betadot = x(14);

u=x(15:end);

%%% Find necessary variables for first order ODEs

%%% Parameters:
R=2.0966;
J1= 220;
J2= 220;
J3=400;
J4 = 50;
m= 3313;
g= 9.8;
me= 195;
rhoe= 6;
rho_mt= sqrt(2);
DL_QT= 60;
p =4;
rho_b= 13;
sig= 0.1;
SW= 43.75;
S_front= 12.3458;
S_fi= 4.3795;
l1=4.09;
l2= 2.805;
l3= 5.68;
l4= 3.49;
A_w=12;
l5= sqrt(A_w*SW);
b=0.1613;
ainfinity= 0.012;
d_f=2;
d_r= 1.0445;
C_Df0= 0.008;
C_r=0.15;
C_f=0.5;
A_f=4;
alpha_max=25*0.0174533;
A_w=12;
S_ri=21.875;
C_w0=0.32;
C_wa=0.5;
C_Dw0=0.008;
C_wdelta=0.15;
J_r=8.5;
theta_d=5*0.0174533;
rho= 1.225;
dxdt=100;
beta_w=45*0.0174533;
k_p1=6;
k_p2=11;
k_p3= 6;
k_a1=6;
k_a2=11;
k_a3=6;
k_1= 5;
k_2=5;
k_3=2.5;
k_4= 4.5;
k_5 =2.63;
k_6 =4.55;
t_1=5;
phi_s= -7*0.0174533;
omega= 16;
T1 =u(1) ;
T2 =u(2) ;
T3= u(3);
T4=u(4) ;

%%Secondary constants from original parameters-convert everything to
%%radians 
V_betax= cos(beta)*U - sin(beta)*W;
V_betaz= sin(beta)*U + cos(beta)*W;
mu_x= V_betax/(omega*R);
mu_z=V_betaz/(omega*R);
A= pi*R^2;
v_1bar= sqrt(T1/(2*rho*A))/(omega*R); %v_i is induced velocity of rotor and omega is rotor speed constant
v_2bar= sqrt(T2/(2*rho*A))/(omega*R);
v_3bar= sqrt(T3/(2*rho*A))/(omega*R);
v_4bar= sqrt(T4/(2*rho*A))/(omega*R);
b_1= b/R;
d_11bar= p*b_1*ainfinity/(3*pi)*(v_1bar+mu_z);
d_12bar=p*b_1*ainfinity/pi*(C_Df0/(4*ainfinity)*(1+mu_x^2)+1/60*(v_1bar+mu_z)*phi_s -0.5*(v_1bar^2+mu_z^2+2*v_1bar*mu_z)) ;
d_21bar= p*b_1*ainfinity/(3*pi)*(v_2bar+mu_z);
d_22bar=p*b_1*ainfinity/pi*(C_Df0/(4*ainfinity)*(1+mu_x^2)+1/60*(v_2bar+mu_z)*phi_s -0.5*(v_2bar^2+mu_z^2+2*v_2bar*mu_z)) ;
d_31bar= p*b_1*ainfinity/(3*pi)*(v_3bar+mu_z);
d_32bar=p*b_1*ainfinity/pi*(C_Df0/(4*ainfinity)*(1+mu_x^2)+1/60*(v_3bar+mu_z)*phi_s -0.5*(v_3bar^2+mu_z^2+2*v_3bar*mu_z)) ;
d_41bar= p*b_1*ainfinity/(3*pi)*(v_4bar+mu_z);
d_42bar=p*b_1*ainfinity/pi*(C_Df0/(4*ainfinity)*(1+mu_x^2)+1/60*(v_4bar+mu_z)*phi_s -0.5*(v_4bar^2+mu_z^2+2*v_4bar*mu_z)) ;
d_11= 0.5*rho*omega^2*R^5*pi*d_11bar;
d_12= 0.5*rho*omega^2*R^5*pi*d_12bar;
d_21= 0.5*rho*omega^2*R^5*pi*d_21bar;
d_22= 0.5*rho*omega^2*R^5*pi*d_22bar;
d_31= 0.5*rho*omega^2*R^5*pi*d_31bar;
d_32= 0.5*rho*omega^2*R^5*pi*d_32bar;
d_41= 0.5*rho*omega^2*R^5*pi*d_41bar;
d_42= 0.5*rho*omega^2*R^5*pi*d_42bar;
h_1= (rho*omega^2*R^4*p*b_1*ainfinity*(1+1.5*mu_x^2))/6 ;
h_12= (rho*omega^2*R^4*p*b_1*ainfinity*((0.05-0.3*mu_x^2)*phi_s-1.5*(v_1bar+mu_z)))/6 ;
h_22= (rho*omega^2*R^4*p*b_1*ainfinity*((0.05-0.3*mu_x^2)*phi_s-1.5*(v_2bar+mu_z)))/6 ;
h_32= (rho*omega^2*R^4*p*b_1*ainfinity*((0.05-0.3*mu_x^2)*phi_s-1.5*(v_3bar+mu_z)))/6 ;
h_42= (rho*omega^2*R^4*p*b_1*ainfinity*((0.05-0.3*mu_x^2)*phi_s-1.5*(v_4bar+mu_z)))/6 ;
V_betat= (d_f + 0.25*d_r)*betadot;
%might want to change atan to radians
alpha_f1= atan((V_betax+V_betat)/(sqrt(T1/(2*rho*A))+V_betaz));%%%%FIX v1
V_rt1=sqrt((V_betax+V_betat)^2+(sqrt(T1/(2*rho*A))+V_betaz)^2);
alpha_f2= atan((V_betax+V_betat)/(sqrt(T2/(2*rho*A))+V_betaz));%%%%FIX v1
V_rt2=sqrt((V_betax+V_betat)^2+(sqrt(T2/(2*rho*A))+V_betaz)^2);
alpha_f3= atan((V_betax+V_betat)/(sqrt(T3/(2*rho*A))+V_betaz));%%%%FIX v1
V_rt3=sqrt((V_betax+V_betat)^2+(sqrt(T3/(2*rho*A))+V_betaz)^2);
alpha_f4= atan((V_betax+V_betat)/(sqrt(T4/(2*rho*A))+V_betaz));%%%%FIX v1
V_rt4=sqrt((V_betax+V_betat)^2+(sqrt(T4/(2*rho*A))+V_betaz)^2);
deltaf=0; delta=0;
C_Lf1= C_f*alpha_f1 +C_r*deltaf;
C_Lf2= C_f*alpha_f2+C_r*deltaf;
C_Lf3= C_f*alpha_f3+C_r*deltaf;
C_Lf4= C_f*alpha_f4+C_r*deltaf;
alpha= atan2(U, W);
C_Lw= C_w0 +C_wa*alpha +C_wdelta*delta;
V_b = sqrt(U^2+W^2); 
f_rd= 0.5*S_front*(V_b^2)*rho*C_Df0; %drag force
f_rl= 0.5*S_front*(V_b^2)*rho*C_Df0; %yaw force
e_w= 1.78 *(1- 0.045*A_w^(0.68))-0.46;
C_Dw= C_Dw0+ C_Lw^2/ (pi*A_w*e_w);
e_f= 1.78 *(1- 0.045*A_f^(0.68))-0.46;
C_Df1= C_Df0 + C_Lf1^2/ (pi*A_f*e_f);
C_Df2= C_Df0 + C_Lf2^2/ (pi*A_f*e_f);
C_Df3= C_Df0 + C_Lf3^2/ (pi*A_f*e_f);
C_Df4= C_Df0 + C_Lf4^2/ (pi*A_f*e_f);

%%Lift, Drag, Blade Torque
L_fixed=0.5*rho*S_ri*C_Lw*V_b^2;
L_56= 2*L_fixed;
Q1= (d_11*T1)/h_1 + (d_12- d_11*h_12/h_1);
Q2= (d_21*T2)/h_1 + (d_22- d_21*h_22/h_1);
Q3= (d_31*T3)/h_1 + (d_32- d_31*h_32/h_1);
Q4= (d_41*T4)/h_1 + (d_42- d_41*h_42/h_1);
L1= 0.5*rho*S_fi*C_Lf1*V_rt1^2;
L2=0.5*rho*S_fi*C_Lf2*V_rt2^2;
L3=0.5*rho*S_fi*C_Lf3*V_rt3^2;
L4=0.5*rho*S_fi*C_Lf4*V_rt4^2;
Lsum= L1+L2+L3+L4;
D_fixed=0.5*rho*S_ri*C_Dw*V_b^2;
D_56= 2*D_fixed;
D1= 0.5*rho*S_fi*C_Df1*V_rt1^2;
D2= 0.5*rho*S_fi*C_Df2*V_rt2^2;
D3= 0.5*rho*S_fi*C_Df3*V_rt3^2;
D4= 0.5*rho*S_fi*C_Df4*V_rt4^2;
Dsum= D1+D2+D3+D4;

%%Get matrices for ODEs
p1= (cos(theta)*cos(psi)*sin(beta)+(sin(psi)*sin(phi)-cos(phi)*sin(theta)*cos(psi))*cos(beta))*(T1+T2+T3+T4);
p2= (-cos(theta)*sin(psi)*sin(beta)+(sin(phi)*cos(psi)+ cos(phi)*sin(theta)*cos(psi))*cos(beta))*(T1+T2+T3+T4);
p3= (sin(theta)*sin(beta)+ cos(phi)*cos(theta)*cos(beta))*(T1+T2+T3+T4);

gp1= (cos(theta)*cos(psi)*sin(alpha)+(sin(phi)*sin(psi)- cos(phi)*sin(theta)*cos(psi))*cos(alpha))*L_56 +...
    (-cos(theta)*cos(psi)*cos(alpha)+(sin(phi)*sin(psi)-cos(phi)*sin(theta)*cos(psi))*sin(alpha))*D_56 +...
    (-cos(theta)*cos(psi)*cos(beta)+(sin(phi)*sin(psi)-cos(phi)*sin(theta)*cos(psi))*sin(beta))*Lsum +...
    (-cos(theta)*cos(psi)*sin(beta)-(sin(phi)*sin(psi)-cos(phi)*sin(theta)*cos(psi))*cos(beta))*Dsum + ...
    (-cos(phi)*sin(psi)-sin(phi)*sin(theta)*cos(psi))*f_rl- cos(theta)*cos(psi)*f_rd;
gp2= (-cos(theta)*sin(psi)*sin(beta)+(sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi)*cos(beta)))*(T1+T2+T3+T4) +...
    (-cos(theta)*sin(psi)*sin(alpha)+(sin(phi)*cos(psi)- cos(phi)*sin(theta)*sin(psi))*cos(alpha))*L_56 +...
    (cos(theta)*sin(psi)*sin(alpha)+(sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi))*sin(alpha))*D_56 +...
    (cos(theta)*sin(psi)*cos(beta)+(sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi))*sin(beta))*Lsum +...
    (cos(theta)*sin(psi)*sin(beta)-(sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi))*cos(beta))*Dsum + ...
    (-cos(phi)*cos(psi)+sin(phi)*sin(theta)*sin(psi))*f_rl+ cos(theta)*sin(psi)*f_rd;
gp3= (sin(theta)*sin(beta)+cos(phi)*cos(theta)*cos(beta))*(T1+T2+T3+T4) + ...
    (sin(theta)*sin(alpha)+cos(pi)*cos(theta)*cos(alpha))*L_56 + ...
    (-sin(theta)*cos(alpha)+cos(phi)*cos(theta)*sin(alpha))*D_56 + ...
    (-sin(theta)*cos(beta)+cos(phi)*cos(theta)*sin(beta))*Lsum + ...
    (-sin(theta)*sin(beta)-cos(phi)*cos(theta)*cos(beta))*Dsum + ...
    sin(phi)*cos(theta)*f_rl -sin(theta)*f_rd - m * g;

%%for hover to level
if t <= t_1
    M_beta= -3; %estimate, can vary
elseif t<=2*t_1 && t>t_1
    M_beta= 3;
else 
    M_beta=0;  
end
%%for level to hover
% if t < t_1
%     M_beta= 3; %estimate, can vary
% elseif t<2*t_1 && t>t_1
%     M_beta= -3;
% else 
%    M_beta=0;  
%end 
u11= (T2-T1)*l1 + (T4-T3)*l2;
u21= (T2+T1)*l4 - (T3+T4)*l3;
u31= Q1-Q2+Q3-Q4;
%ua.u_ac= [ua.u_11; ua.u_21; ua.u_31];
u22= (L3+L4)*l3;
%ua.u_as= [ua.u_31; ua.u_22; ua.u_11];
%ua= cos(beta)*ua.u_ac + sin(beta)*ua.u_as;

a1= (L_fixed- L_fixed)*l5*cos(alpha) + ((L2-L1)*l1+(L3-L4)*l2)*sin(beta);
a2= (L1 +L2)*l4*sin(beta)- ((L3)^2+(L4)^2)*l3*sin(beta);
a3= (L_fixed-L_fixed)*l5*sin(alpha) + ((L2-L1)*l1 +(L3-L4)*l2*cos(beta)+f_rl*l3);


%%% Error estimates
delta1 = 50*(2*exp(-2*t)*sin(3*t)+exp(-t)*cos(t));
delta2 = 50*(exp(-t)*sin(3*t)+2*exp(-0.5*t)*cos(t));
delta3= 50*(0.5*exp(-t)*sin(3*t)+3*exp(-2*t)*cos(t));
delta4 = 20*(0.5*exp(-2*t)*sin(3*t)+0.8*exp(-t)*cos(t));
delta5 = 20*(0.5*exp(-t)*sin(3*t)+0.5*exp(-0.5*t)*cos(t));
delta6 = 20*(2*exp(-2*t)*sin(3*t)+0.5*exp(-t)*cos(t));

%%% First order ODE equations

xd4= cos(theta)*cos(psi)*U + (-cos(phi)*sin(psi)+sin(phi)*sin(theta)*cos(psi))*V + (sin(phi)*sin(psi)+cos(phi)*sin(theta)*cos(psi))*W;
xd5 = cos(theta)*sin(psi)*U + (cos(phi)*sin(psi)+sin(phi)*sin(theta)*sin(psi))*V + (-sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi))*W;
xd6 = -sin(theta)*U + sin(phi)*cos(theta)*V + cos(phi)*cos(theta)*W;
xd1= (1/m)*(p1 + gp1 + delta1);
xd2= (1/m)*(p2 + gp2+ delta2);
xd3= (1/m)*(p3 + gp3 +delta3);
xd10= P + sin(phi)*tan(theta)*Q + cos(phi)*tan(theta)*R;
xd11= cos(phi)*Q - sin(phi)*R;
xd12= sin(phi)*sec(theta)*Q + cos(phi)*sec(theta)*R;
xd7= ((cos(beta)*u11 +sin(beta)*u31)+ a1 + delta4)/J1 ;
xd8= (1/J2)* ((cos(beta)*u21 +sin(beta)*u22)+ M_beta + a2 + delta5);
xd9= (1/J3)* ((cos(beta)*u31 -sin(beta)*u11)+ a3 + delta6);
% if flightsys.transition
%     xd13= betadot;
%     xd14= -M_beta/J4;
% else
xd13=0;
xd14=0;
xdot = [xd1;xd2;xd3;xd4;xd5;xd6;xd7;xd8;xd9;xd10;xd11;xd12;xd13;xd14;0;0;0;0];

HEB=DCMI(P, Q, R);
alphad=alpha*57.2958;
Va= [U;V;W];
V=sqrt(Va' * Va);
qbar=0.5 * rho * V^2;
IAS=sqrt(2 * qbar / 1.225);
flightsys.vkias = IAS/0.5154;
flightsys.alpha = alphad;
flightsys.alphar=alpha;
flightsys.b2e = HEB;
flightsys.V = V;
flightsys.beta = 0;
flightsys.betar=0;
flightsys.qbarS=qbar*SW;
flightsys.mass = m;
flightsys.chord = 1.6;
ve = [x(1);x(2);x(3)]
rpy= [x(7); x(8); x(9)]
T= [T1;T2;T3;T4]
%disp(T)
end