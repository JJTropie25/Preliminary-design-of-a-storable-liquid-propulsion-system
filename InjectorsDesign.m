function [INJECTORS] = InjectorsDesign(mdot,OF,rho_fu,rho_ox,Pc)

% INPUT
% mdot=mass flow rate [kg/s]
% OF=oxidizer to fuel ratio
% rho_fu=fuel density [kg/m^3]
% rho_ox=oxidizer density [kg/m^3]
% Pc=chamber pressure [Pa]
%
% OUTPUT
% INJECTORS=[N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,
%            m_ox_inj_real,m_fu_inj_real,v_ox_inj,v_fu_inj]
% 1-N_ox_real=oxidizer injector number
% 2-N_fu_real=fuel injector number
% 3-A_ox_inj_real=oxidizer injector area [m^2]
% 4-A_fu_inj_real=fuel injector area [m^2]
% 5-m_ox_inj_real=oxidizer injector mass flow rate [kg/s]
% 6-m_fu_inj_real=fuel oxidizer mass flow rate [kg/s]
% 7-v_ox_inj=oxidizer injection velocity [m/s]
% 8-v_fu_inj=fuel injection velocity [m/s]


% mu_fu=0.97/1000;   %viscosity [cP] -> [kg/(m*s)]
% mu_ox=0.47/1000;
% Ac=0.0021; % section of combustion chamber

cD=0.7;     % discharge coefficient
dP=Pc*0.2;  % pressure drop in injection plate fixed to 20% of the Pc value

% mass flow rate of fuel and oxidizer 
m_fu=mdot/(1+OF);
m_ox=mdot-m_fu;

% numbers and size of holes (doublet)
[N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,m_ox_inj_real,m_fu_inj_real]=holes_doublet(m_ox,m_fu,rho_ox,rho_fu,dP,cD);

% Verify feasibility of holes in the injection plates
% D_ox=2*(sqrt(A_ox_inj_real/pi));
% D_fu=2*(sqrt(A_fu_inj_real/pi));
% N_ox_real*A_ox_inj_real+N_fu_real*A_fu_inj_real % total area of holes
% Ac % injection plate size comparable with c.c. section

% Numbers and size of holes (triplet)
% c=2; % to obtain triplet N_ox=2*N_fu
% [N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,m_ox_inj_real,m_fu_inj_real]=holes_general(m_ox,m_fu,rho_ox,rho_fu,dP,cD,c);

% Verify feasibility of holes in the injection plates
% N_ox_real*A_ox_inj_real+N_fu_real*A_fu_inj_real % total area of holes
% Ac % injection plate size comparable with c.c. section

% oxidizer and fuel injection velocity [m/s]
v_ox_inj=cD*sqrt(2*dP/rho_ox);
v_fu_inj=cD*sqrt(2*dP/rho_fu);

INJECTORS=[N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,m_ox_inj_real,m_fu_inj_real,v_ox_inj,v_fu_inj];

end













