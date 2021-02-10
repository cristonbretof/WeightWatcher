close all
clear all
clc

% identification de la poutre

h = 1.610e-3;        %Hauteur 1.61 mm
d_h = 0.5e-6;        %Incertitude relative
dp_h = d_h/h;        %Incertitude absolue

b = 73.635e-3;       %Base 7.3 cm
d_b = 0.5e-6;        %Incertitude relative
dp_b = d_b/b;        %Incertitude absolue

L = 301.570e-3;      %Longeur 31.1 cm
d_L = 0.5e-6;        %Incertitude relative
dp_L = d_L/L;        %Incertitude absolue

J = L*h^3/12;                  %Moment d'aire
dp_J = (dp_L+(3*dp_h))/12;     %Incertitude absolue

m = 6.95e-3;          %Masse 69.5 g
d_m = 0.0005;         %Incertitude relative
dp_m = d_m/m;         %Incertitude absolue

%Matériau

mu =  m/L;            %Masse linéique kg/m
dp_mu = dp_m + dp_L;  %Incertitude absolue

dens = m/(b*h*L);               %Densité Kg/m^3
dp_dens = dp_b+dp_h+dp_L+dp_m;  %Insertitude absolue

f = 11.5;                   %Fréquance propre 11.5 batements par seconde
d_f = 0.5;                  %Incertitude relative
dp_f = d_f/f;               %Incertitude absolue

w = 2*pi*f;                 %Fréquance propre rad par seconde
dp_w = dp_f*w;

R = 1.8751;

E = w^2*(L/R)^4*mu/J;                    % Module de Young Pa
dp_e = dp_w*2 + dp_L*4 + dp_mu + dp_J;   %Incertitude absolue

dt = 6e-5;       % incrément temporel

nx = 70;         % Nb d'éléments spatiaux
nt = 5000;       % Nb d'éléments temporels

dx =   L/(nx-1);      % incrément spatial
x  = -dx:dx:L+dx;     % grille spatiale
nx = nx+2;

dx_n = dx/L;     % On travaille en dx normalisé

% Stiffness params

kappa = E*J/mu;

% Doit être supérieur à 1/4 pour que ca soit stable
mu_simu = kappa*dt^2/dx_n^4

if(mu_simu < 1/4)
       warning('La simulation ne sera pas stable !')
end

%% Conditions initiales


