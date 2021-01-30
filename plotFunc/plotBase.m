function plotBase(total_width, total_height, lame_width, lame_height)
%PLOTBASE Fonction permettant de présenter la base de la balance
%   On utilise cette fonction pour présenter les éléments statiques de la
%   balance. On appelle cette fonction seulement lorsqu'on réinitialise le
%   simulateur. La représentation est en 2D.

base_height = total_height/5; % Hauteur de la base

fixbar_height = total_height/2; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_width = base_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_x_pos = 0; % Position en x de de la plaque tenant la fixe
topfix_y_pos = fixbar_height+base_height+0.95*lame_width; % Position en y de la fixe au-dessus de la lame
fix_height = 0.05*total_height; % Hauteur (épaisseur) de la fixe supérieure

action_height = fixbar_height-0.75; % Hauteur de l'actionneur
action_width = total_width/5; % Largeur de l'actionneur
pos_x_actionneur = total_width/2-action_width/2; % Position en x de l'actionneur

% Définition de la figure (même que les parties dynamiques)
figure(1)

% Limites de l'illustration (montage)
axis([-2 total_width+2 0-2 total_height+2])

hold on

% Base de métal du montage
rectangle('Position',[0,0,total_width,base_height], ...
    'FaceColor',[0.5,0.5,0.5]);

% Fixe de métal tenant la lame
rectangle('Position',[fixbar_x_pos,base_height,fixbar_width, ...
    fixbar_height],'FaceColor',[0.5,0.5,0.5]);
rectangle('Position',[fixbar_x_pos,topfix_y_pos,fixbar_width, ...
    fix_height],'FaceColor',[0.5,0.5,0.5]);

% L'actionneur devrait resté à une taille statique (à changer)
% Actionneur linéaire
rectangle('Position',[pos_x_actionneur,base_height,action_width, ...
    action_height],'FaceColor',[0.7,0.1,0.05]);

% Bobine de l'actionneur linéaire
rectangle('Position',[pos_x_actionneur+action_width*0.05, ...
    base_height+action_height,action_width*0.9,action_height*0.2], ...
    'FaceColor',[0.6,0.1,0.05]);

% Plaque tenant le capteur choisi
rectangle('Position',[total_width-fixbar_x_pos-fixbar_width,base_height,...
    fixbar_width,1.10*fixbar_height],'FaceColor',[0.5,0.5,0.5]);

plotCapt(total_width,total_height,1.10*fixbar_height,"Capacitive");

hold off
end


