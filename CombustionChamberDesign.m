function [COMBUSTIONCHAMBER] = CombustionChamberDesign(Lstar,At,Ac,Dc,rho,mdot,g,MM,Tc)

% INPUT
% Lstar=combustion chamber characteristic length (from tables) [m] 
% At=throat area [m^2]
% Ac=combustion chamber area [m^2]
% Dc=combustion chamber diameter [m]
% rho=gas density [kg/m^3]
% mdot=mass flow rate [kg/s]
% g=gamma
% MM=molar mass [kg/kmol]
% Tc=temperature in combustion chamber [K]
%
% OUTPUT
% COMBUSTIONCHAMBER=[Vc Lc t_res Mc];
% 1-Vc=chamber volume [m^3]
% 2-Lc=chamber length [m]
% 3-t_res=residence time [s]
% 4-Mc=chamber mach number


Ru= 8.314;         % universal gas constant [J/mol*K]
R = (Ru/MM)*10^3;  % Gas constant [J/kg*K]

Vc=Lstar*At;  % [m^3] combustion chamber volume

% cilindrical combustion chamber
Lc=Vc/(pi*(Dc/2)^2);  % [m] combustion chamber length

t_res=Lstar*rho*At/mdot;  % [s] residence time

% mach number check
uc=mdot/rho/Ac;      % [m/s] velocity in combustion chamber
Mc=uc/sqrt(g*R*Tc);  % [-] combustion chamber mach number

% % plot  SISTEMARE
contraction_ratio=linspace(1,30,1000);
comb_chamb_length=@(x)Vc./(pi*(sqrt(4*At*x/pi)/2).^2); % SISTEMARE
plot(contraction_ratio,comb_chamb_length(contraction_ratio)*1000,'k-')
grid on
title('combustion chamber length VS contraction ratio')
xlabel('contraction ratio \epsilon_c [-]')
ylabel('combustion chamber length L_c_c [mm]')

COMBUSTIONCHAMBER=[Vc Lc t_res Mc];

end
