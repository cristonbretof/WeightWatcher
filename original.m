close all
clear all
clc


% La poutre
b = 73.635e-3;       %Base 7.3 cm
h = 1.610e-3;        %Hauteur 1.61 mm
L = 301.570e-3;      %Longeur 31.1 cm

J = b*h^3/12;    % Moment d'aire

m = 6.95e-2;          %Masse 69.5 g

% Mat�riau

f = 11.5;                   %Fr�quance propre 11.5 batements par seconde
w = 2*pi*f;                 %Fr�quance propre rad par seconde
R = 1.8751;


dens = m/(b*h*L);               %Densit� Kg/m^3
mu =  m/L;            %Masse lin�ique kg/m
E = w^2*(L/R)^4*mu/J;                    % Module de Young Pa


dt = 6e-5;       % incr�ment temporel

nx = 20;         % Nb d'�l�ments spatiaux
nt = 5000;       % Nb d'�l�ments temporels


dx =   L/(nx-1); % incr�ment spatial
x  = -dx:dx:L+dx;     % grille spatiale
nx = nx+2;

dx_n = dx/L;     % On travaille en dx normalis�

% Stiffness params

kappa = sqrt(E*J/(mu*L^4));

% Doit �tre inf�rieur � 1/2 pour que ca soit stable
mu_simu = kappa*dt/dx_n^2;

if(mu_simu >1/2)
       warning('La simulation ne sera pas stable !')
end

f1 = sqrt( (1.875/L).^4*(E*J/mu))/(2*pi)  % Fr�qunce theorique de la fondamentale
f1 = 1.875^2*kappa/(2*pi)
%f1 = 4.73^2*kappa/(2*pi)  %% Clamped condition

%% Conditions initiales

temps = 0;
w = 1*fliplr(0.001*sin(pi*x/(2*L))-0.001);  % Conditions actuelles
w_old = w;                                  % un pas dans le pass�
w_new = zeros(1,nx);                        % ce qui sera calcul� � chaque tour
w_init =w;                                  % Pr�servation de la condition initiale


%% Vecteur qui condiendra la position de l'extr�mit� de la lame en fonction
% du temps

masse_bout =zeros(1,nt+1);

%% Pr�calcul des params de simulation pour acc�lerer la boucle

 
coeff1 = (2-6*mu_simu^2);
coeff2 = (4*mu_simu^2);
coeff3 = -mu_simu^2;


%% Pr�paration de la figure

h=plot(x,1000*w_init,x,1000*w_new)
xlabel('x [m]')
ylabel('D�flexion [mm]')
ylim([-1.2,1.2])
grid on


%% Boucle de simulation
for n=0:nt 
    %n
    w_new = zeros(1,nx) ;
    

    i = 3:nx-2;
    w_new(i) = coeff1*w(i)+coeff2*(w(i+1)+w(i-1))+coeff3*(w(i+2)+w(i-2))-w_old(i);
    %% Conditions limites 
 
     w_new(1:2) =0;                 % Clamp� � zero, position et d�riv�e nulle
   
     w_new(end-1) = 2*w_new(end-2)-w_new(end-3);    % Libre au bout d�riv�es 2e et 3e nulles
     w_new(end) = 2*w_new(end-1)-w_new(end-2);
   %  w_new(end-1:end)=0;           % Si on veut clamp� au deux bouts
    
    %% Pr�paration du prochain tour
    
    w_old = w;
    w = w_new;
    
    masse_bout(n+1) = w(end);
    
    %% Affichage
 
    set(h(2),'Ydata',1000*w_new);
    drawnow 
%     %pause
    
end

%%
figure
plot((0:dt:(nt*dt)),masse_bout)
grid
