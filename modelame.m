close all
clear all
clc


% La poutre
b = 73.3e-3;        % Base 6 cm
t = 1.82e-3;     % Hauteur 1.56 mm
L = 247e-3;     % Longueur 24.6 cm 

J = (b*t^3)/12;    % Moment d'aire

% Matériau

E = 13.1e9;      % Module de Young  70 GPa (Alu)
dens = 1730.784297;
%dens = 1730.784297;% Densité Kg/m^3
m_lame = dens*b*t*L;
mu =  m_lame/L;  % Masse linéique kg/m


dt = 3e-5;       % incrément temporel

nx = 25;         % Nb d'éléments spatiaux
nt = 150000;       % Nb d'éléments temporels


dx =   L/(nx-1); % incrément spatial
x  = -dx:dx:L+dx;     % grille spatiale
nx = nx+2;

dx_n = dx/L;     % On travaille en dx normalisé
%Gamma :
Gamma = 1.10923090e1;
%Amortissement:
A = -0.0258;
%masse ajoutee:
liste_masse = [0.0, 0.005, 0.01, 0.015, 0.02, 0.025, 0.03, ...
    0.035, 0.04, 0.045, 0.05, 0.055, 0.06, 0.065, 0.07, 0.075, ...
    0.08, 0.085, 0.09, 0.095, 0.1];
masse_finale = zeros(1,length(liste_masse));
for lol=1:length(liste_masse)
mo = liste_masse(lol); %Masse objet kg
ma = 51.2e-3; %masse actionneur
m = mo+ma+mu*L;
amo = -Gamma*m;

% Stiffness params

kappa = sqrt(E*J/(mu*L^4));

% Doit être inférieur à 1/2 pour que ca soit stable
mu_simu = kappa*dt/dx_n^2;

if(mu_simu >1/2)
       warning('La simulation ne sera pas stable !')
end
 f1 = sqrt((E*(t*b)^2)/((L^4)*0.9465*dens));
%f1 = sqrt( (1.875/L).^4*(E*J/mu))/(2*pi)  % Fréqunce theorique de la fondamentale
%f1 = 1.875^2*kappa/(2*pi)
%f1 = 4.73^2*kappa/(2*pi)  %% Clamped condition


%% Conditions initiales

temps = 0;
%w = 1*fliplr(0.001*sin(pi*x/(2*L))-0.001);% Conditions actuelles
w =(zeros(27));
w_old = w;                                  % un pas dans le passé
w_new = zeros(1,nx);                        % ce qui sera calculé à chaque tour
w_init =w;                                  % Préservation de la condition initiale


%% Vecteur qui condiendra la position de l'extrémité de la lame en fonction
% du temps

masse_bout =zeros(1,nt+1);

%% Précalcul des params de simulation pour accélerer la boucle

 
coeff1 = ((6*E*J*(dt^2)/((dx^4)*(amo*dt-mu)))-((2*mu)/(amo*dt-mu))+((amo*dt)/(amo*dt-mu)));
coeff2 = ((4*E*J*dt^2)/((dx^4)*(amo*dt-mu)));
coeff3 = ((E*J*(dt^2))/((dx^4)*(amo*dt-mu)));
coeff4 = ((mu)/(amo*dt-mu));
coeff5 = ((dt^2)/(dx*(amo*dt-mu)));
%coeff1 = (2-6*mu_simu^2);
%coeff2 = (4*mu_simu^2);
%coeff3 = -mu_simu^2;
%coeff4 = amo/mu;
%coeff5 = ((dt^2/dx)/mu);
Fo = mo * (-9.81); %Force de l'objet ajoute
Fa = ma * (-9.81); %Force actionneur
liste = [0.05020070175438597, 0.0664421052631579, ...
    0.08120701754385966, 0.09892491228070176, 0.11664280701754387, ...
    0.13532042105263156, 0.15355508771929824, 0.17437361403508772, ...
    0.1960042105263158, 0.22147368421052632, 0.2399298245614035, ...
    0.2628154385964912, 0.28422456140350877, 0.30770077192982453, ...
    0.33147228070175444, 0.35583438596491224, 0.38167298245614034, ...
    0.4112028070175439, 0.43777964912280704, 0.4665712280701755, ...
    0.49683929824561407];
Fe = liste(lol); %force electromag
pp = b*t*L*dens;
Fp = pp*(-9.81);

vecteur_forces = zeros(1,nx);
vecteur_forces(14) = Fo+Fa+Fe;
Hum = ones(1,nx);
vecteur_poutre = (Fp/nx)*Hum;

%% Préparation de la figure

% h=plot(x,1000*w_init,x,1000*w_new);
% xlabel('x [m]')
% ylabel('Déflexion [mm]')
% ylim([-5,5])
% xlim([0,0.35])
% grid on    
    %% Boucle de simulation
    for n=0:nt 
        %n


        w_new = zeros(1,nx) ;



        i = 3:nx-2;
        w_new(i) =(coeff1*w(i)-coeff2*(w(i+1)+w(i-1))+coeff3*(w(i+2)+w(i-2))+w_old(i)*coeff4-coeff5*(vecteur_forces(i)+vecteur_poutre(i)));
        %w_new(i) = (1/(1+dt*coeff4))*(coeff1*w(i)+coeff2*(w(i+1)+w(i-1))+coeff3*(w(i+2)+w(i-2))-w_old(i)+coeff4*w(i)*dt + (dt^2/dx)*(vecteur_forces(i)+vecteur_poutre(i))/mu);
        %% Conditions limites 

         w_new(1:2) =0;                 % Clampé à zero, position et dérivée nulle

         w_new(end-1) = 2*w_new(end-2)-w_new(end-3);    % Libre au bout dérivées 2e et 3e nulles
         w_new(end) = 2*w_new(end-1)-w_new(end-2);
       %  w_new(end-1:end)=0;           % Si on veut clampé au deux bouts

        %% Préparation du prochain tour

        w_old = w;
        w = w_new;

        masse_bout(n+1) = w(end);


        %% Affichage

        %set(h(2),'Ydata',1000*w_new);
        %drawnow 
    %     %pause  

    end
masse_finale(lol) = masse_bout(end);
    %%
%     figure(lol)
%     plot((0:dt:(nt*dt)),masse_bout)
%     grid
end

figure
plot(liste,masse_finale,'o')

grid


