function mid_y = plotLame(app,ypos_init,lame_length,lame_array,lame_width)
%PLOTLAME Fonction permettant d'afficher la lame en action
%   On se sert de cette fonction pour afficher dynamiquement la lame
%   lorsqu'on fait une simulation du système. La torsion ainsi que la
%   position de la lame change selon le nombre et le poids des pièces mise
%   sur le plateau.

% Define initial values (x,y)
plot_array = lame_array + ypos_init;
n_plot_array = 0:0.1:lame_length-1;

plot(app,n_plot_array,plot_array,'LineWidth',lame_width);
mid_y = plot_array(ceil(numel(plot_array)/2));

end

