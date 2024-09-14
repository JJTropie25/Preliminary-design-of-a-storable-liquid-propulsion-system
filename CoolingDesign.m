function [COOLING] = CoolingDesign(Lc,M,T0,g,MM,rho,cp,K,mu,mdot,OF,D,Lcon,Ldiv,cp_f)

% INPUT
% vectors elements are taken in A(c.c.), B(t.), C(e.) sections
% M=mach number [1x3] [-]
% T0=flame temperature i combustion chamber [K]
% g=gamma [-]
% MM=molar mass [kg/kmol]
% rho=gas density [1x3] [kg/m^3]
% Pc=chamber pressure [Pa]
% cp=specific heat at constant pressure [1x3] [J/kgK]
% K=thermal conductivity [1x3] [W/mK]
% mu=gas viscosity [1x3] [Pas]
% mdot=mass flow rate [kg/s]
% OF=oxidizer to fuel ratio [-]
% D=sections diameter [m]
% Lconv=convergent part length [m]
% Ldiv=divergent part length [m]
% cp_f=fuel specific heat at constant pressure [J/kgK]
%
% OUTPUT
% COOLING=[delta_T_cc delta_T_noz_conv delta_T_noz_div 
%          delta_T Qcc Qnoz_con Qnoz_div q(1) q(2) q(3)];
% 1-delta_T_cc=temperature increase in chamber [K]
% 2-delta_T_noz_conv=temperature increase in nozzle convergent part [K]
% 3-delta_T_noz_div=temperature increase in nozzle divergent part [K]
% 4-delta_T=total temperature increase [K]
% 5-Qcc=heat power in chamber [W]
% 6-Qnoz_con=heat power in nozzle convergent part [W]
% 7-Qnoz_div=heat power in nozzle divergent part [W]
% 8-q(1)=heat flux in chamber [W/m^2]
% 9-q(2)=heat flux in nozzle convergent part [W/m^2]
% 10-q(3)=heat flux in nozzle divergent part [W/m^2]

Ru=8.314; % universal gas constant [J/mol*K]
R=(Ru/MM)*10^3; % Gas constant [J/kg*K]

Tstat=T0./(1+(g-1)/2.*M.^2);
v=sqrt(g.*R.*Tstat).*M;

T_wg=1600;  % [K] max temperature we want the gas-side wall to reach

Dc=D(1);
Dt=D(2);
De=D(3);

% Hot gas side
q=[];
for i=1:3
    qnew=hotgasside(T0,g,M(i),rho(i),v(i),D(i),mu(i),cp(i),K(i),T_wg);
    % This is the value we need to dissipate
    q=[q qnew];
end

% Coolant side (c.c.)
% only fuel is used as coolant
mf=mdot/(1+OF); 
qcc=q(1); % q needed to be dissipated in c.c.

Acc_lat=pi*Dc*Lc; % wall surface of c.c.

Qcc=qcc*Acc_lat;          % total heat exchanged in combustion chamber walls
delta_T_cc=Qcc/(cp_f*mf); % difference of temperature of cooling fluid (fuel) along c.c.
% then we'll apply different strategies (material, thermal barrier and
% varying r) in order to reduce this value

% Coolant side (nozzle)
% "Mesh" approach
% we chose to perform a similar procedure in the nozzle as for the c.c.,
% but considering a mesh of its sections.
% needed input vectors of properties along the nozzle
%
% delta_T_nozzle=0;
% 
% for i=1:n
% 
% qnew=hotgassside(T_noz,P_noz,y,M_noz,MM,v_norho_noz,z,D_noz,mu_noz,cp_noz,K_noz,T_wg);
% 
% Qnew=qnew*Anoz_lat(i);
% 
% delta_Tnew=Qnew/(cp_f*mf);
% 
% delta_T_nozzle=delta_T_nozzle+delta_Tnew;
% 
% end

% "Convergent+divergent" approach
A_noz_lat_conv=pi*Lcon*(Dc/2+Dt/2); % area of a conical trunk
A_noz_lat_div=pi*Ldiv*(Dt/2+De/2); % SA = (π/6)(r/h²)[(r² + 4h²)3/2 - r³]
Qnoz_con=q(2)*A_noz_lat_conv;  % overextimated
Qnoz_div=q(3)*A_noz_lat_div; % underextimated

% the error in the two computations balances
% then we can compute the rise in temperature of the coolant liquid (fuel) along
% the entire nozzle 

delta_T_noz_conv=(Qnoz_con)/(cp_f*mf);
delta_T_noz_div=(Qnoz_div)/(cp_f*mf);

% Total delta T on the fuel (coolant)
delta_T=delta_T_cc+delta_T_noz_conv+delta_T_noz_div;

COOLING=[delta_T_cc delta_T_noz_conv delta_T_noz_div delta_T Qcc Qnoz_con Qnoz_div q(1) q(2) q(3)];

end
