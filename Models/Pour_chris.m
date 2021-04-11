function w  = pos_lame(mo, Fe, d, t, L, E, m_lame, ma, Gamma, dens, wn, pos_act)
J = (t*d^3)/12    % Moment d'aire

dens = m_lame/(L*t*d)
m_lame = dens*d*t*L;
mu =  m_lame/L;
mu = dens*d*t % Masse linéique kg/m 
dt = 3e-6;       % incrément temporel
E = (wn^2)*mu*L^4/
nx = 25;         % Nb d'éléments spatiaux
nt = 250000;       % Nb d'éléments temporels


dx =   L/(nx-1); % incrément spatial
x  = -dx:dx:L+dx;     % grille spatiale
nx = nx+2;

dx_n = dx/L;     % On travaille en dx normalisé

m = mo+ma+mu*L;
amo = -Gamma*m;

kappa = sqrt(E*J/(mu*L^4));

% Doit être inférieur à 1/2 pour que ca soit stable
mu_simu = kappa*dt/dx_n^2

if(mu_simu >1/2)
       warning('La simulation ne sera pas stable !')
end


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

Fo = mo * (-9.81); %Force de l'objet ajoute
Fa = ma * (-9.81); %Force actionneur

Fp = m_lame*(-9.81);
vecteur_objet = zeros(1,nx);
vecteur_objet(pos_obj) = Fo;
vecteur_actionneur = zeros(1,nx)
vecteur_actionneur(pos_act) = Fa + Fe;
Hum = ones(1,nx);
vecteur_poutre = (Fp/nx)*Hum;
vecteur_forces = zeros(1,nx);
vecteur_forces = vecteur_objet + vecteur_actionneur + vecteur_poutre -13.48366993*mo^2 + 6.70935401*mo + 1.01130627;


%% Boucle de simulation
for n=0:nt 
    %n
    w_new = zeros(1,nx) ;
    i = 3:nx-2;
    w_new(i) =(coeff1*w(i)-coeff2*(w(i+1)+w(i-1))+coeff3*(w(i+2)+w(i-2))+w_old(i)*coeff4-coeff5*(vecteur_forces(i));
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
    
    
    
end
end