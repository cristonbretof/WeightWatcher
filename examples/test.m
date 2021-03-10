close all
clear all
clc


% La poutre
b = 73.635e-3;       %Base 7.3 cm
h = 1.610e-3;        %Hauteur 1.61 mm
L = 301.570e-3;      %Longeur 31.1 cm

J = b*h^3/12;    % Moment d'aire

m = 6.95e-2;          % Masse 69.5 g

% Matériau

f = 11.5;                   %Fréquance propre 11.5 batements par seconde
w = 2*pi*f;                 %Fréquance propre rad par seconde
R = 1.8751;


dens = m/(b*h*L);               %Densité Kg/m^3
mu =  m/L;            %Masse linéique kg/m
E = w^2*(L/R)^4*mu/J;                    % Module de Young Pa

A = 0.0258;

dt = 6e-5;       % incrément temporel

nx = 20;         % Nb d'éléments spatiaux
nt = 5000;       % Nb d'éléments temporels


dx =   L/(nx-1); % incrément spatial
x  = -dx:dx:L+dx;% grille spatiale
nx = nx+2;

dx_n = dx/L;     % On travaille en dx normalisé

% Stiffness params

kappa = sqrt(E*J/(mu*L^4));

% Doit être inférieur à 1/2 pour que ca soit stable
mu_simu = kappa*dt/dx_n^2;

if(mu_simu >1/2)
       warning('La simulation ne sera pas stable !')
end

Kb = 0.728;

F = 1;

f1 = sqrt( (1.875/L).^4*(E*J/mu))/(2*pi);  % Fréqunce theorique de la fondamentale
f1 = 1.875^2*kappa/(2*pi);
%f1 = 4.73^2*kappa/(2*pi)  %% Clamped condition

%% Conditions initiales

temps = 0;
w = 1*fliplr(0.001*sin(pi*x/(2*L))-0.001);  % Conditions actuelles
w_old = w;                                  % un pas dans le passé
w_new = zeros(1,nx);                        % ce qui sera calculé à chaque tour
w_init =w;                                  % Préservation de la condition initiale


%% Vecteur qui contiendra la position de l'extrémité de la lame en fonction
% du temps

masse_bout =zeros(1,nt+1);

%% Précalcul des params de simulation pour accélerer la boucle


%% Préparation de la figure

h=plot(x,1000*w_init,x,1000*w_new);
xlabel('x [m]')
ylabel('Déflexion [mm]')
ylim([-1.2,1.2])
grid on


%% Boucle de simulation
for n=0:nt 
    %n
    w_new = zeros(1,nx) ;
    

    i = 3:nx-2;
%     F*(dx^3)*(dt^3)-
%     w_new(i) = -coeff3*w(i)+coeff2*(w(i+1)+w(i-1))+coeff1*(w(i+2)+w(i-2))+coeff4-w_old(i);
    w_new(i) = (F*(dx^3)*(dt^3)-E*J*(dt^3)*(w(i+2)-4*w(i+1)+6*w(i)-4*w(i-1)-w(i-2))+mu*(dx^4)*dt*(-2*w(i)-w_old(i))-A*(dx^4)*(dt^2)*(-w(i)))/(mu*(dx^4)*dt-A*(dx^4)*(dt^2));
    %% Conditions limites 
     w_new(1:2) =0;                 % Clampé à zero, position et dérivée nulle
   
     w_new(end-1) = 2*w_new(end-2)-w_new(end-3);    % Libre au bout dérivées 2e et 3e nulles
     w_new(end) = 2*w_new(end-1)-w_new(end-2);
%     w_new(end-1:end)=0;           % Si on veut clampé au deux bouts
    
    %% Préparation du prochain tour
    
    w_old = w;
    w = w_new;
    
    masse_bout(n+1) = w(end);
    
    %% Affichage
 
    set(h(2),'Ydata',1000*w_new);
    drawnow 
end

%%
figure
plot((0:dt:(nt*dt)),masse_bout)
grid


