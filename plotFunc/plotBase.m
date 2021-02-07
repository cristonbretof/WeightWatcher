function plotBase(app,total_length,total_height,lame,lame_length,lame_width,action_mid_x)
%PLOTBASE Fonction permettant de présenter la base de la balance
%   On utilise cette fonction pour présenter les éléments statiques de la
%   balance. On appelle cette fonction seulement lorsqu'on réinitialise le
%   simulateur. La représentation est en 2D.

base_height = 0.1*total_height; % Hauteur de la base

fixbar_height = total_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_width = 2*base_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_x_pos = 0; % Position en x de de la plaque tenant la fixe

action_height = 0.75*fixbar_height; % Hauteur de l'actionneur
action_width = 3*fixbar_width; % Largeur de l'actionneur

% Position de la lame en hauteur
plot_y_pos = base_height + 0.95*fixbar_height;

% Lame flexible
mid_y = plotLame(app,plot_y_pos,lame_length,lame,lame_width);

hold on

% Base de métal du montage
rectangle(app,'Position',[0,0,total_length,base_height], ...
    'FaceColor',[0.5,0.5,0.5]);

% Fixe de métal tenant la lame
rectangle(app,'Position',[fixbar_x_pos,base_height,fixbar_width, ...
    fixbar_height],'FaceColor',[0.5,0.5,0.5]);

% Actionneur linéaire
rectangle(app,'Position',[action_mid_x*total_length,base_height,action_width, ...
    action_height],'FaceColor',[0.7,0.1,0.05]);

% Plaque tenant le capteur choisi
rectangle(app,'Position',[total_length-fixbar_x_pos-fixbar_width, ...
    base_height,fixbar_width,fixbar_height],'FaceColor', ...
    [0.5,0.5,0.5]);

% Capteur capacitif
plotCapt(app,total_length,total_height,fixbar_height,"Capacitive");

% Bobine de l'actionneur linéaire (hauteur variable)
plotAction(app,action_mid_x*total_length+0.15*action_width, ...
    base_height+action_height,action_width*0.7,...
    mid_y-action_height-base_height);

% Plateau pour les pièces
rectangle(app,'Position',[action_mid_x*total_length,mid_y,action_width, ...
    base_height/4],'FaceColor',[0.6,0.6,0.6]);

end


