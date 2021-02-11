function plotBase(link,total_length,total_height,action_mid_x, ...
    bob_radius,lame,lame_length,lame_width,capt_length,capt_spacing)
%PLOTBASE Fonction permettant de présenter la base de la balance
%   On utilise cette fonction pour présenter les éléments statiques de la
%   balance. On appelle cette fonction seulement lorsqu'on réinitialise le
%   simulateur. La représentation est en 2D.

base_height = 0.1*total_height; % Hauteur de la base

capt_thickness = 0.4;

fixbar_height = total_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_width = base_height; % Hauteur de la plaque de métal tenant la fixe pour la lame
fixbar_x_pos = 0; % Position en x de de la plaque tenant la fixe

action_height = 0.75*fixbar_height; % Hauteur de l'actionneur
action_width = 3*bob_radius; % Largeur de l'actionneur (base)

% Position de la lame en hauteur
lame_y_pos = base_height + fixbar_height - capt_spacing/2;
lame_array = lame + lame_y_pos;

% Lame flexible (definition)
n_plot_array = 0:0.1:lame_length-1;
plot(link,n_plot_array,lame_array,'LineWidth',lame_width);

% Emplacement du point (sur la lame) qui sera suivi par l'actionneur et le plateau
mid_y = lame_array(ceil(numel(lame_array)/2));

hold on

% Base de métal du montage
rectangle(link,'Position',[0,0,total_length,base_height], ...
    'FaceColor',[0.5,0.5,0.5]);

% Fixe de métal tenant la lame
rectangle(link,'Position',[fixbar_x_pos,base_height,fixbar_width, ...
    fixbar_height],'FaceColor',[0.5,0.5,0.5]);

% Actionneur linéaire
rectangle(link,'Position',[action_mid_x*total_length,base_height,action_width, ...
    action_height],'FaceColor',[0.7,0.1,0.05]);

% Plaque tenant le capteur choisi
rectangle(link,'Position',[total_length-fixbar_width, ...
    base_height,fixbar_width,fixbar_height],'FaceColor', ...
    [0.5,0.5,0.5]);

% Capteur capacitif
% Position de l'électrode supérieure sur la base (barre fixe)
top_height = base_height + fixbar_height - capt_thickness;

% Électrode supérieure du capteur
rectangle(link,'Position',[total_length-capt_length,top_height, ...
    capt_length,capt_thickness],'FaceColor',[0.7,0.2,0.05]);
% Électrode inférieure du capteur
rectangle(link,'Position',[total_length-capt_length,top_height-capt_spacing, ...
    capt_length,capt_thickness],'FaceColor',[0.7,0.2,0.05]);

% Bobine de l'actionneur linéaire (hauteur variable)
rectangle(link,'Position',[action_mid_x*total_length+0.5*bob_radius, ...
    base_height+action_height,2*bob_radius,...
    mid_y-action_height-base_height],'FaceColor',[0.6,0.1,0.05]);

% Plateau pour les pièces
rectangle(link,'Position',[action_mid_x*total_length,mid_y,action_width, ...
    0.5],'FaceColor',[0.6,0.6,0.6]);

end
