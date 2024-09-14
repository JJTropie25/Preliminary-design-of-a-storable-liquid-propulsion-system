function q=hotgasside(T_0,y,M,rho,v,D,mu,cp,K,T_wg)


% Nusselt correlation
Re=rho*v*D/mu; % must be >=10000 for the model
Pr=cp*mu/K;    % 0.7<=Pr<=160 for the model

% Using the model in the validity range -> Dittus Boelter (also verify L/D)
C=0.0265; x=0.8; n=0.3; % cooling 
Nu=C*(Re^x)*(Pr^n);

% Invert Nusselt definition to compute h
hg=Nu*K/D;
Rec=(1+(Pr^(1/3))*((y-1)/2)*M^2)/(1+((y-1)/2)*M^2); % Recovery factor
T_aw=Rec*T_0; % adiabatic wall temperature

% Required heat flux as a result
q=hg*(T_aw-T_wg);

% This is the value we need to dissipate

end
