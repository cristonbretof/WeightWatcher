function plotLame(link,ypos_init,lame_array,lame_width)
%PLOTLAME Fonction permettant d'afficher la lame en action
%   On se sert de cette fonction pour afficher dynamiquement la lame
%   lorsqu'on fait une simulation du système. La torsion ainsi que la
%   position de la lame change selon le nombre et le poids des pièces mise
%   sur le plateau.

plot_array = lame_array + ypos_init;
n_plot_array = 0:1:numel(plot_array)-1;

plot(link,n_plot_array,plot_array,'LineWidth',lame_width);

end

