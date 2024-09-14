function NozzlePlot(Ltot_RAO,Ltot,Dc,Dt,De,Lc,Lcon,ep)

% INPUT;
% Ltot_RAO=RAO nozzle length [m]
% Ltot=conical nozzle length [m]
% Dc=combustion chamber diameter [m]
% Dt=throat diameter [m]
% De=exit diameter [m]
% Lc=Combustion chamber length [m]
% Lcon=convergent length [m]
% ep=area ratio


L_tot_conic=Lc+Ltot;
beta=45;
R_c=Dc/2; R_t=Dt/2; R_e=De/2;

% RAO NOZZLE
% Let us find the angle of the 1.5*R_t arc connecting the C.C. with the nozzle
f=@(x)(1.7*R_t*(sind(270-x)+1)+R_t)-R_c;
angle_1_5_R_t = fsolve(f,beta);

% 1.5 R_t circle
h=0.001; % plot discretization
thetad_1=270-angle_1_5_R_t:h:270; % we will use [deg] in order to avoid the otherwise present floating point errors (e.g. cos(pi) = 6.12323399573677e-17)
x_1=1.7*R_t*cosd(thetad_1);
y_1=1.7*R_t*(sind(thetad_1)+1)+R_t;

dl=(Dc/2-y_1(1))/tand(45);
dx=x_1(1):-h:x_1(1)-dl;
yob=linspace(y_1(1),Dc/2,length(dx));

% Combustion chamber
x_cc=dx(end):-h:-Lc+dx(end);
y_cc=ones(1,length(x_cc))*Dc/2;

% plot
figure
plot(x_cc,y_cc,'k','LineWidth',2)
hold on
grid on
axis equal
plot(x_1, y_1,'k','LineWidth',2)
plot(dx,yob,'k','LineWidth',2)

theta_i=deg2rad(27.2); % deg

thetad_2=thetad_1(end):h:270+rad2deg(theta_i);
x_2=0.4*R_t*cosd(thetad_2);
y_2=0.4*R_t*(sind(thetad_2)+1)+R_t;
plot(x_2,y_2,'k','LineWidth',2)

x_N=x_2(end);
y_N=y_2(end);
% x_E=Ltot_RAO-abs(x_1(1));
y_E=sqrt(ep)*R_t;

% x = ay^2+by+c
A_parabSys=[2*y_N   1 0;
            R_e^2 R_e 1;
            y_N^2 y_N 1];
b_parabSys=[1/tan(theta_i) Ltot_RAO x_N]';               
parCoeffs=A_parabSys\b_parabSys;

y_3=y_2(end):h:y_E;
x_3=parCoeffs(1)*y_3.^2+parCoeffs(2)*y_3+parCoeffs(3);
plot(x_3,y_3,'k','LineWidth',2)
hold on


% CONIC NOZZLE 
x_ax=(0:0.0001:L_tot_conic); % m 
xcc_end=round(Lc*10000);
xc_in=xcc_end+1;
xc_end=round((Lc+Lcon)*10000);
xl_in=xc_end + 1;
% costruisco il vettore diametro
D=[];
for i=1:length(x_ax)  
    if i<=xcc_end
        D(i)=Dc;
    elseif i>=xc_in && i<=xc_end
        D(xc_in:xc_end)=linspace(Dc,Dt,(xc_end-xc_in+1));
    elseif i>=xl_in
        D(i)=Dt + 2*tan(15*pi/180)*(x_ax(i)-(xc_end/10000));
    end
end

%plot(x_ax-xc_end/10000,-D/2,'k','linewidt',2)
plot(x_ax-abs(x_cc(end)),-D/2,'k','linewidt',2)
%plot([x_ax(1)-xc_end/10000,x_ax(end)-xc_end/10000],[0,0],'k--','linewidt',1)
plot([x_ax(1)-abs(x_cc(end)),x_ax(end)-abs(x_cc(end))],[0,0],'k--','linewidt',1)
hold off
xlabel('Axial distance from throat [m]')
ylabel('Radius [m]')
axis equalend

