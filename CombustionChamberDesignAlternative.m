function [COMBUSTIONCHAMBER] = CombustionChamberDesignAlternative(Lstar,At,rho,mdot,g,MM,Tc)

% INPUT
% Lstar=combustion chamber characteristic length (from tables) [m] 
% At=throat area [m^2]
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
% 5-ep_c=contraction ratio 


Ru= 8.314;         % universal gas constant [J/mol*K]
R=(Ru/MM)*10^3;  % Gas constant [J/kg*K]

% mach number in chamber assumption
Mc=0.1; % [-]
uc=Mc*sqrt(g*R*Tc);  % [m/s] combustion chamber flow velocity

Ac=mdot/rho/uc;    % [m^2] chamber area
Dc=2*sqrt(Ac/pi);  % [m] chamber section diameter

Vc=Lstar*At;  % [m^3] combustion chamber volume

% cilindrical combustion chamber
Lc=Vc/(pi*(Dc/2)^2);  % [m] combustion chamber length

t_res=Lstar*rho*At/mdot;  % [s] residence time

% contraction ratio check
ep_c=Ac/At;

% % plot  SISTEMARE
% contraction_ratio=linspace(1,30,1000);
% comb_chamb_length=@(x)Vc./(pi*(sqrt(4*At*x/pi)/2).^2); % SISTEMARE
% plot(contraction_ratio,comb_chamb_length(contraction_ratio)*1000,'k-')
% grid on
% title('combustion chamber length VS contraction ratio')
% xlabel('contraction ratio \epsilon_c [-]')
% ylabel('combustion chamber length L_c_c [mm]')

COMBUSTIONCHAMBER=[Vc Lc t_res Mc ep_c];

end