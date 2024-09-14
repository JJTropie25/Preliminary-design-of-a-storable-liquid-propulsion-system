function [N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,m_ox_inj_real,m_fu_inj_real]=holes_general(m_ox,m_fu,rho_ox,rho_fu,dP,cD,c)

% INPUT
% m_ox=oxidizer mass flow rate [kg/s]
% m_fu=fuel mass flow rate [kg/s]
% rho_ox=oxidizer density [kg/m^3]
% rho_fu=fuel density [kg/m^3]
% dP=injection pressure loss [Pa]
% cD=discharge coefficient
% c=ratio between number of holes

% OUTPUT
% N_ox_real=oxidizer injector number
% N_fu_real=fuel injector number
% A_ox_inj_real=oxidizer injector area [m^2]
% A_fu_inj_real=fuel injector area [m^2]
% m_ox_inj_real=oxidizer injector mass flow rate [kg/s]
% m_fu_inj_real=fuel oxidizer mass flow rate [kg/s]

% we start imposing the size of the oxidizer holes
D_min=5e-4;   % fix fuel hole as minimum hole diameter possible with additive manufacturing
A_fu_inj=pi*D_min^2/4;
m_fu_inj=cD*A_fu_inj*sqrt(2*dP*rho_fu);
N_fu_real=round(m_fu/m_fu_inj); % round to obtain an entire value
m_fu_inj_real=m_fu/N_fu_real; % real value (back procedure) after obtaining the rounded real number of holes
A_fu_inj_real=m_fu_inj_real/(cD*sqrt(2*dP*rho_ox));

% we need to estabilish the number of injection holes for the fuel
% (chosen configuration is like-on-like doublet)

% c ratio between number of holes
N_ox_real=c*N_fu_real;
m_ox_inj_real=m_ox/N_ox_real;
A_ox_inj_real=m_ox_inj_real/(cD*sqrt(2*dP*rho_ox));

end


