function plotLame(app,lame_length,lame_array,lame_width)
%PLOTLAME Fonction permettant d'afficher la lame en action
%   On se sert de cette fonction pour afficher dynamiquement la lame
%   lorsqu'on fait une simulation du syst�me. La torsion ainsi que la
%   position de la lame change selon le nombre et le poids des pi�ces mise
%   sur le plateau.

% Define initial values (x,y)
n_plot_array = 0:0.1:lame_length-1;

plot(app,n_plot_array,lame_array,'LineWidth',lame_width);

end

