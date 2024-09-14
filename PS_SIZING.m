%% BIPROPELLANT LIQUID KICK STAGE ROCKET ENGINE SIZING

close all
clear
clc

%% SPECIFICATIONS

dv=2500; % [m/s] velocity variation
mdry=250; % [kg] dry mass

%% ENVIRONMENT

Pa=0;    % [Pa] operative atmospheric pressure
g0=9.81; % [m/s^2] gravitational acceleration at sea level
R=8.314;  % [J/molK] universal gas constant

%% DATA from other kick stage rocket engines

T=200;    % [N] thrust
Pc=8e5;   % [Pa] chamber pressure
ep=150;   % [-] area ratio
OF=0.9;   % [-] oxidizer to fuel ratio
% eps_c=6; % [-] contraction ratio

%% CEA CHEMICAL ANALYSIS 
% (BRAY MODEL: expansion from combustion chamber to throat and frozen from throat to exit)

Pt=4.5257e5;
Pe=0.00186e5;

Tc=2847.36;
Tt=2623.31;
Te=441.70;

rhoc=0.61270;
rhot=0.37858;
rhoe=9.2626e-4;

MM=18.246;

cpc=2.4070;
cpt=2.3767;
cpe=1.7106;

muc=0.89910e-2;
mut=0.84938e-2;
mue=0.22248e-2;

Kc=0.34747;
Kt=0.32087;
Ke=0.06304;

c_star=1770.4;

% assumption: cp hydrazine constant
cp_f=1.55945;

rho_fu=1004.5;
rho_ox=1450;

g=cpe/(cpe-R/MM);  % [-] specific heat ratio 

%% NOZZLE DESIGN

% [NOZZLE]=NozzleDesign(Pc,ep,eps_c,g,Pa,T,Tc,MM);

[NOZZLE]=NozzleDesignAlternative(Pc,ep,g,Pa,T,Tc,MM);

%% COMBUSTION CHAMBER DESIGN

Lstar=0.762; % [m] chamber characteristic length

% assumption: contraction ratio
% [COMBUSTIONCHAMBER]=CombustionChamberDesign(Lstar,NOZZLE(7),NOZZLE(6),NOZZLE(9),rhoc,NOZZLE(5),g,MM,Tc);

% assumption: chamber mach number
[COMBUSTIONCHAMBER]=CombustionChamberDesignAlternative(Lstar,NOZZLE(6),rhoc,NOZZLE(5),g,MM,Tc);
[NOZZLEPLUS]=NozzleDesignCompletement(T,COMBUSTIONCHAMBER(5),NOZZLE(8),NOZZLE(9));

%% INJECTORS DESIGN

[INJECTORS]=InjectorsDesign(NOZZLE(5),OF,rho_fu,rho_ox,Pc);

%% COOLING DESIGN

% [COOLING]=CoolingDesign(COMBUSTIONCHAMBER(2),[COMBUSTIONCHAMBER(4) 1 NOZZLE(26)],Tc,g,MM,[rhoc rhot rhoe],[cpc cpt cpe],[Kc Kt Ke],[muc mut mue],NOZZLE(5),OF,[NOZZLE(9) NOZZLE(10) NOZZLE(11)],NOZZLE(19),NOZZLE(20),cp_f);

[COOLING]=CoolingDesign(COMBUSTIONCHAMBER(2),[COMBUSTIONCHAMBER(4) 1 NOZZLE(10)],Tc,g,MM,[rhoc rhot rhoe],[cpc cpt cpe],[Kc Kt Ke],[muc mut mue],NOZZLE(5),OF,[NOZZLEPLUS(2) NOZZLE(8) NOZZLE(9)],NOZZLEPLUS(10),NOZZLEPLUS(11),cp_f);

%% PRESSURE-FEED DESIGN


