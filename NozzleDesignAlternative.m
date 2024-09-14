function [NOZZLE] = NozzleDesignAlternative(Pc,ep,g,Pa,T,Tc,MM)

% INPUT:
% Pc=combustion chamber pressure [Pa]
% ep=area ratio
% g=gamma
% Pa=ambient pressure [Pa]
% T=vacuum thrust [N]
% Tc=combustion chamber temperature [K]
% MM=molar mass [kg/kmol]
%
% OUTPUT:
% NOZZLE=[Pe ct Is ve mdot At Ae Dt De Me];
% 1-Pe=exit pressure [Pa]
% 2-ct=thrust coefficient
% 3-Is=specific impulse [s]
% 4-ve=exit velocity [m/s]
% 5-mdot=mass flow rate [kg/s]
% 6-At=throat area [m^2]
% 7-Ae=exit area [m^2]
% 8-Dt=throat diameter [m^2]
% 9-De=exit diameter [m^2]
% 10-Me=exit mach number


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

De=sqrt(4*Ae/pi);  % [m] exit section diameter 
Dt=sqrt(4*At/pi);  % [m] throat section diameter

ve=sqrt(2*g/(g-1)*R*Tc*(1-(Pe/Pc)^((g-1)/g)));  % [m/s] exit velocity
mdot=(T-(Pe-Pa)*Ae)/ve;                         % [kg/m^2] mass flow rate
Is=T/mdot/g0;                                   % [s] specific impulse

% exit mach number
fun=@(x)1/x*sqrt(2/(g+1)*(1+(g-1)/2*x^2)^((g+1)/(g-1)));
Me=fzero(fun,1);


NOZZLE=[Pe ct Is ve mdot At Ae Dt De Me];

end
