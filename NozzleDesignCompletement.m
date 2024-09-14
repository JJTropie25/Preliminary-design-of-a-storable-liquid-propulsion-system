function [NOZZLEPLUS] = NozzleDesignCompletement(T,ep_c,Dt,De)

% INPUT:
% Pc=combustion chamber pressure [Pa]
% ep=area ratio
% ep_c=contraction ratio
% g=gamma
% Pa=ambient pressure [Pa]
% T=vacuum thrust [N]
% Tc=combustion chamber temperature [K]
% MM=molar mass [kg/kmol]
%
% OUTPUT:
% NOZZLEPLUS=[Ac Dc alpha beta Lcon Ldiv Ltot thetai thetae Lcon_RAO 
%         Ldiv_RAO Ltot_RAO lambda_conical T1D lambda_RAO T1D_RAO];
% 1-Ac=combustion chamber area [m^2]
% 2-Dc=combustion chamber diameter [m^2]
% 3-alpha=angle of the divergent wall [rad]
% 4-beta=angle of the convergent wall [rad]
% 5-Lcon=length of the convergent [m]
% 6-Ldiv=length of the divergent [m]
% 7-Ltot=total length [m]
% 8-thetai=initial parabola angle [rad] 
% 9-thetae=final parabola angle [rad] 
% 10-Lcon_RAO=length of the convergent RAO [m]
% 11-Ldiv_RAO=length of the divergent RAO [m]
% 12-Ltot_RAO=total length RAO [m]
% 13-lambda_conical=conical divergence losses
% 14-T1D=conical 1D thrust [N]
% 15-lambda_RAO=RAO divergence losses
% 16-T1D_RAO=RAO 1D thrust [N]


alpha=deg2rad(15);  % [rad] angle of the divergent wall  
beta=deg2rad(45);   % [rad] angle of the convergent wall 

lambda_conical=(1+cos(alpha))/2;  % efficiency of the divergent part of the nozzle
T1D=T/lambda_conical;             % [N] 1D thrust computed from the nominal one 

Ac=ep_c*pi*(Dt/2)^2;
Dc=2*sqrt(Ac/pi);
Lcon=(Dc-Dt)/(2*tan(beta));   % [m] length of the convergent of the nozzle 
Ldiv=(De-Dt)/(2*tan(alpha));  % [m] length of the divergent of the nozzle 
Ltot=Lcon+Ldiv;               % [m] total nozzle length

% RAO nozzle - minimum length
% from RAO tables for the imposed eps and 60% of length take the values

thetai=deg2rad(41.7);  % [rad] initial parabola angle
thetae=deg2rad(4.4);   % [rad] final parabola angle

Lcon_RAO=Lcon;           % [m] RAO nozzle convergent part length
Ldiv_RAO=0.6*Ldiv;       % [m] RAO nozzle divergent part length
Ltot_RAO=Lcon_RAO+Ldiv_RAO;  % [m] RAO nozzle total length

alpha_prime=atan((De-Dt)/2/Ldiv); 
lambda_RAO=1/2*(1+cos((alpha_prime+thetae)/2));  % [-] RAO divergence losses

T1D_RAO=T/lambda_RAO;  % [N] monodimensional thrust

NOZZLEPLUS=[Ac Dc alpha beta Lcon Ldiv Ltot thetai thetae Lcon_RAO Ldiv_RAO Ltot_RAO lambda_conical T1D lambda_RAO T1D_RAO];

end

