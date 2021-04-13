figure()
total_length = 0.247*100;
total_height = 0.150*100;
action_mid_x = 0.100*100;
bob_radius = 0.012*100;
lame = zeros(1,(round(total_length)-1)+1);
lame_length = 0.247*100;
capt_length = total_length/4;
capt_spacing = (0.00457*1000)/2;

base_height = 0.09*total_height; % Hauteur de la base

capt_thickness = 0.2*base_height;

fixbar_height = total_height; % Hauteur de la plaque de m�tal tenant la fixe pour la lame
fixbar_width = base_height*0.8; % Hauteur de la plaque de m�tal tenant la fixe pour la lame
fixbar_x_pos = 0; % Position en x de de la plaque tenant la fixe

action_height = 0.85*fixbar_height; % Hauteur de l'actionneur
action_width = 4*bob_radius; % Largeur de l'actionneur (base)

% Position de la lame en hauteur
lame_y_pos = base_height + fixbar_height - capt_spacing/3;
lame_array = lame + lame_y_pos;

% Lame flexible (definition)
n_plot_array = 0:1:ceil(lame_length)-1;
plot(n_plot_array,lame_array,'LineWidth',3.5);

% Emplacement du point (sur la lame) qui sera suivi par l'actionneur et le plateau
mid_y = lame_array(ceil(numel(lame_array)/2));

hold on

% Base de m�tal du montage
rectangle('Position',[0,0,total_length,base_height], ...
    'FaceColor',[0.5,0.5,0.5]);

% Fixe de m�tal tenant la lame
rectangle('Position',[fixbar_x_pos,base_height,fixbar_width, ...
    fixbar_height],'FaceColor',[0.5,0.5,0.5]);

% Actionneur lin�aire
rectangle('Position',[action_mid_x,base_height,action_width, ...
    action_height],'FaceColor',[0.7,0.1,0.05]);

% Plaque tenant le capteur choisi
rectangle('Position',[total_length-fixbar_width, ...
    base_height,fixbar_width,fixbar_height],'FaceColor', ...
    [0.5,0.5,0.5]);

% Capteur capacitif
% Position de l'�lectrode sup�rieure sur la base (barre fixe)
top_height = base_height + fixbar_height - capt_thickness;

% �lectrode sup�rieure du capteur
rectangle('Position',[total_length-capt_length,top_height, ...
    capt_length,capt_thickness],'FaceColor',[0.7,0.2,0.05]);

% �lectrode inf�rieure du capteur
rectangle('Position',[total_length-capt_length,top_height-capt_spacing/1.9, ...
    capt_length,capt_thickness],'FaceColor',[0.7,0.2,0.05]);

% Bobine de l'actionneur lin�aire (hauteur variable)
rectangle('Position',[action_mid_x+0.15*action_width, ...
    base_height+action_height,0.7*action_width,...
    mid_y-action_height-base_height],'FaceColor',[0.6,0.1,0.05]);

% Plateau pour les pi�ces
rectangle('Position',[action_mid_x,mid_y,action_width, ...
    0.5],'FaceColor',[0.6,0.6,0.6]);
