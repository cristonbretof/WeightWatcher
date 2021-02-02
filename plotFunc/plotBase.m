function plotBase(link,total_width,total_height,lame,lame_width)
%PLOTBASE Fonction permettant de présenter la base de la balance
%   On utilise cette fonction pour présenter les éléments statiques de la
%   balance. On appelle cette fonction seulement lorsqu'on réinitialise le
%   simulateur. La représentation est en 2D.

base_height = 0.2*total_height; % Hauteur de la base

fixbar_height = 0.5*total_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_width = base_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_x_pos = 0; % Position en x de de la plaque tenant la fixe

action_height = 0.75*fixbar_height; % Hauteur de l'actionneur
action_width = 0.2*total_width; % Largeur de l'actionneur
pos_x_actionneur = total_width/2-action_width/2; % Position en x de l'actionneur

% Position de la lame en hauteur
plot_y_pos = base_height + 0.95*fixbar_height;

% Lame flexible
plotLame(link,plot_y_pos,lame,lame_width);

hold on

% Base de métal du montage
rectangle(link,'Position',[0,0,total_width,base_height], ...
    'FaceColor',[0.5,0.5,0.5]);

% Fixe de métal tenant la lame
rectangle(link,'Position',[fixbar_x_pos,base_height,fixbar_width, ...
    fixbar_height],'FaceColor',[0.5,0.5,0.5]);

% Actionneur linéaire
rectangle(link,'Position',[pos_x_actionneur,base_height,action_width, ...
    action_height],'FaceColor',[0.7,0.1,0.05]);

% Plaque tenant le capteur choisi
rectangle(link,'Position',[total_width-fixbar_x_pos-fixbar_width, ...
    base_height,fixbar_width,fixbar_height],'FaceColor', ...
    [0.5,0.5,0.5]);

% Capteur capacitif
plotCapt(link,total_width,total_height,fixbar_height,"Capacitive");

% Bobine de l'actionneur linéaire
plotAction(link,pos_x_actionneur+action_width*0.15, ...
    base_height+action_height,action_width*0.7, ...
    plot_y_pos-action_height-base_height);

hold off

end


