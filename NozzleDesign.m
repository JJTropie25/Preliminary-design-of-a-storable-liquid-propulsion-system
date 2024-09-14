function [NOZZLE] = NozzleDesign(Pc,ep,ep_c,g,Pa,T,Tc,MM)

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
% NOZZLE=[Pe ct Is ve mdot Ac At Ae Dc Dt De alpha beta Lcon Ldiv Ltot 
%         thetai thetae Lcon_RAO Ldiv_RAO Ltot_RAO lambda_conical T1D 
%         lambda_RAO T1D_RAO Me];
% 1-Pe=exit pressure [Pa]
% 2-ct=thrust coefficient
% 3-Is=specific impulse [s]
% 4-ve=exit velocity [m/s]
% 5-mdot=mass flow rate [kg/s]
% 6-Ac=combustion chamber area [m^2]
% 7-At=throat area [m^2]
% 8-Ae=exit area [m^2]
% 9-Dc=combustion chamber diameter [m^2]
% 10-Dt=throat diameter [m^2]
% 11-De=exit diameter [m^2]
% 12-alpha=angle of the divergent wall [rad]
% 13-beta=angle of the convergent wall [rad]
% 14-Lcon=length of the convergent [m]
% 15-Ldiv=length of the divergent [m]
% 16-Ltot=total length [m]
% 17-thetai=initial parabola angle [rad] 
% 18-thetae=final parabola angle [rad] 
% 19-Lcon_RAO=length of the convergent RAO [m]
% 20-Ldiv_RAO=length of the divergent RAO [m]
% 21-Ltot_RAO=total length RAO [m]
% 22-lambda_conical=conical divergence losses
% 23-T1D=conical 1D thrust [N]
% 24-lambda_RAO=RAO divergence losses
% 25-T1D_RAO=RAO 1D thrust [N]
% 26-Me=exit mach number


Ru=8.314; % universal gas constant [J/mol*K]
R=(Ru/MM)*10^3; % Gas constant [J/kg*K]
g0=9.81; % [m/s^2] gravitational acceleration at sea level

% pressure ratio computation
FUN=@(x)((g+1)/2)^(1/(g-1))*(x/Pc)^(1/g)*sqrt((g+1)/(g-1)*(1-(x/Pc)^((g-1)/g)))-1/ep;
Pe=fzero(FUN,[0 101325]); % [Pa] exit pressure

% [-] thrust coefficient
ct=sqrt(2*g^2/(g-1)*(2/(g+1))^((g+1)/(g-1)))*sqrt(1-(Pe/Pc)^((g-1)/g))+((Pe-Pa)/Pc)*ep; 

At=T/(Pc*ct);  % [m^2] throat area  
Ae=At*ep;      % [m^2] external area 
Ac=At*ep_c;    % [m^2] combustion chamber area

De=sqrt(4*Ae/pi);  % [m] exit section diameter 
Dt=sqrt(4*At/pi);  % [m] throat section diameter
Dc=sqrt(4*Ac/pi);  % [m] combustion chamber section diameter

ve=sqrt(2*g/(g-1)*R*Tc*(1-(Pe/Pc)^((g-1)/g)));  % [m/s] exit velocity
mdot=(T-(Pe-Pa)*Ae)/ve;                         % [kg/m^2] mass flow rate
Is=T/mdot/g0;                                   % [s] specific impulse

% exit mach number
fun=@(x)1/x*sqrt(2/(g+1)*(1+(g-1)/2*x^2)^((g+1)/(g-1)));
Me=fzero(fun,1);

alpha=deg2rad(15);  % [rad] angle of the divergent wall  
beta=deg2rad(45);   % [rad] angle of the convergent wall 

lambda_conical=(1+cos(alpha))/2;  % efficiency of the divergent part of the nozzle
T1D=T/lambda_conical;             % [N] 1D thrust computed from the nominal one 

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

NOZZLE=[Pe ct Is ve mdot Ac At Ae Dc Dt De alpha beta Lcon Ldiv Ltot thetai thetae Lcon_RAO Ldiv_RAO Ltot_RAO lambda_conical T1D lambda_RAO T1D_RAO Me];

end

