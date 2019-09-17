function [CD,CL,CY,Cl,Cm,Cn,Thrust]	=	AeroModelMach(x,u,Mach,alphar,betar,V)
%Modified from Stengel.
global m Ixx Iyy Izz Ixz S b c
%	Typical Mass and Inertial Properties
	m		=	4536;				% Mass, kg
	Ixx		=	35926.5;			% Roll Moment of Inertia, kg-m^2
	Iyy		=	33940.7;			% Pitch Moment of Inertia, kg-m^2
	Izz		=	67085.5;			% Yaw Moment of Inertia, kg-m^2
	Ixz		=	3418.17;			% Nose-high(low) Product of Inertia, kg-m^2
	
%	Geometric Properties
	c		=	2.14;				% Mean Aerodynamic Chord, m
	b		=	10.4;				% Wing Span, m
	S		=	21.5;				% Reference Area, m^2
	ARw		=	5.02;				% Wing Aspect Ratio
	taperw	=	0.507;				% Wing Taper Ratio
	sweepw	=	13 * .01745329;		% Wing 1/4-chord sweep angle, rad
	ARh		=	4;					% Horizontal Tail Aspect Ratio
	sweeph	=	25 * .01745329;		% Horiz Tail 1/4-chord sweep angle, rad
	ARv		=	0.64;				% Vertical Tail Aspect Ratio
	sweepv	=	40 * .01745329;		% Vert Tail 1/4-chord sweep angle, rad
	lvt		=	4.72;				% Vert Tail Length, m
	
%	Thrust Properties
	StaticThrust	=	26243.2;	% Static Thrust @ Sea Level, N
	
%	Current Thrust
	[airDens,airPres,temp,soundSpeed] = Atmos(-x(6));
    
	Thrust			=	u(4) * StaticThrust * (airDens / 1.225)^0.7
									% Thrust at Altitude, N
%	Current Mach Effects, normalized to Test Condition B (Mach = 0.1734)
	PrFac			=	1 / (sqrt(1 - Mach^2) * 1.015);	
									% Prandtl Factor
	WingMach		=	1 / ((1 + sqrt(1 + ((ARw/(2 * cos(sweepw)))^2) ...
						* (1 - Mach^2 * cos(sweepw)))) * 0.268249);
									% Modified Helmbold equation
	HorizTailMach	=	1 / ((1 + sqrt(1 + ((ARh/(2 * cos(sweeph)))^2) ...
						* (1 - Mach^2 * cos(sweeph)))) * 0.294539);
									% Modified Helmbold equation
	VertTailMach	=	1 / ((1 + sqrt(1 + ((ARv/(2 * cos(sweepv)))^2) ...
						* (1 - Mach^2 * cos(sweepv)))) * 0.480338);
									% Modified Helmbold equation
	
%	Current Longitudinal Characteristics
%	====================================

%	Lift Coefficient
	CLo		=	0.1095;				% Zero-AoA Lift Coefficient (B)
	CLar	=	5.6575;				% Lift Slope (B), per rad
	CLqr    =	4.231 * c / (2 * V);
									% Pitch-Rate Effect, per rad/s
	CLdEr	=	0.5774;				% Elevator Effect, per rad
	CL	=	CLo + (CLar*alphar + CLqr*x(8) + CLdEr*u(1))* WingMach;
                                    % Total Lift Coefficient, w/Mach Correction
	
%	Drag Coefficient
	CDo		=	0.0255;				% Parasite Drag Coefficient (B)
	epsilon	=	0.0718;				% Induced Drag Factor
	CD	=	CDo * PrFac + epsilon * CL^2;
                                    % Total Drag Coefficient, w/Mach Correction
	
%	Pitching Moment Coefficient
	Cmo		=	0;					% Zero-AoA Moment Coefficient (B)
	Cmar	=	-1.231;				% Static Stability (B), per rad
	Cmqr    =	 -18.8 * c / (2 * V);
                                    % Pitch-Rate + Alpha-Rate Effect, per
                                    % rad/s
	CmdEr	=	-1.398;				% Elevator Effect, per rad
	Cm	=	Cmo + (Cmar*alphar + Cmqr*x(8) + CmdEr*u(1))* HorizTailMach;
                                    % Total Pitching Moment Coefficient, w/Mach Correction
	
%	Current Lateral-Directional Characteristics
%	===========================================

%	Side-Force Coefficient
	CYBr	=	-0.7162;			% Side-Force Slope (B), per rad
	CYdAr	=	-0.00699;			% Aileron Effect, per rad
	CY	=	(CYBr*betar) * VertTailMach + (CYdAr*u(2)) * WingMach;
                                    % Total Side-Force Coefficient, w/Mach Correction

%	Yawing Moment Coefficient
	CnBr	=	0.1194;				% Directional Stability (B), per rad
	Cnpr	=	CL * (1 + 3 * taperw)/(12 * (1 + taperw)) * (b / (2 * V));				
									% Roll-Rate Effect, per rad/s
	Cnrr	=	(-2 * (lvt / b) * CnBr * VertTailMach - 0.1 * CL^2) ...
				* (b / (2 * V));				
									% Yaw-Rate Effect, per rad/s
	CndAr	=	0;                      % Aileron Effect, per rad	
	Cn	=	(CnBr*betar ) * VertTailMach ...
			+ Cnrr * x(9) + Cnpr * x(7) ...
			+ (CndAr*u(2)) * WingMach;
                                        % Total Yawing-Moment Coefficient,
                                        % w/Mach Correction
%	Rolling Moment Coefficient
	ClBr	=	-0.0918;                % Dihedral Effect (B), per rad
	Clpr	=	-CLar * (1 + 3 * taperw)/(12 * (1 + taperw)) ...
				* (b / (2 * V));				
                                        % Roll-Rate Effect, per rad/s
	Clrr	=	(CL * (1 + 3 * taperw)/(12 * (1 + taperw)) ...
				* ((Mach * cos(sweepw))^2 - 2) / ((Mach * cos(sweepw))^2 - 1)) ...
				* (b / (2 * V));				
                                        % Yaw-Rate Effect, per rad/s
	CldAr	=	0.1537;                 % Aileron Effect, per rad

	Cl	=	(ClBr*betar ) * VertTailMach ... 
			+ Clrr * x(9) + Clpr * x(7) ...
			+ (CldAr*u(2) ) * WingMach;
                                        % Total Rolling-Moment Coefficient,
                                        % w/Mach Correction