function [N_ox_real,N_fu_real,A_ox_inj_real,A_fu_inj_real,m_ox_inj_real,m_fu_inj_real]=holes_doublet(m_ox,m_fu,rho_ox,rho_fu,dP,cD)

% INPUT
% m_ox=oxidizer mass flow rate [kg/s]
% m_fu=fuel mass flow rate [kg/s]
% rho_fu=fuel density [kg/m^3]
% rho_ox=oxidizer density [kg/m^3]
% dP=injection pressure loss [Pa]
% cD=discharge coefficient

% OUTPUT
% N_ox_real=oxidizer injector number
% N_fu_real=fuel injector number
% A_ox_inj_real=oxidizer injector area [m^2]
% A_fu_inj_real=fuel injector area [m^2]
% m_ox_inj_real=oxidizer injector mass flow rate [kg/s]
% m_fu_inj_real=fuel oxidizer mass flow rate [kg/s]


% fix oxidizer hole as minimum hole diameter possible with additive manufacturing
margin=1.5;
D_min=margin*5e-4;  % fix oxidizer hole as minimum hole diameter possible with additive manufacturing

% we start imposing the size of the oxidizer holes
A_ox_inj=D_min^2/4*pi;
m_ox_inj=cD*A_ox_inj*sqrt(2*dP*rho_ox);
N_ox=m_ox/m_ox_inj;
N_ox_real=round(N_ox);  % round to obtain an entire value

if N_ox_real/2-round(N_ox_real/2)~=0  % check if the number of holes is even 
    N_ox_real=N_ox_real-1;            % if the number of holes is odd we subtract one 
    % (adding one would mean more smaller holes and that would be a problem)
end

m_ox_inj_real=m_ox/N_ox_real;
A_ox_inj_real=m_ox_inj_real/(cD*sqrt(2*dP*rho_ox));

% same procedure for the fuel
A_fu_inj=pi*D_min^2/4;
m_fu_inj=cD*A_fu_inj*sqrt(2*dP*rho_fu);
N_fu=m_fu/m_fu_inj;
N_fu_real=round(N_fu);  % round to obtain an entire value

if N_fu_real/2-round(N_fu_real/2)~=0  % check if the number of holes is even 
    N_fu_real=N_fu_real-1;            % if the number of holes is odd we subtract one 
    % (adding one would mean more smaller holes and that would be a problem)
end

m_fu_inj_real=m_fu/N_fu_real;
A_fu_inj_real=m_fu_inj_real/(cD*sqrt(2*dP*rho_fu));

end
