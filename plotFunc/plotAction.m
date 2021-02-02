function plotAction(link,xpos,ypos,width,height)
%PLOTACTION Fonction permettant de présenter l'actionneur linéaire
%   Il est possible avec cette fonction de faire monter et descendre la
%   hauteur de l'actionneur linéaire en fonction de la lame sur le dessus.

% Actionneur linéaire
rectangle(link,'Position',[xpos,ypos,width,height], ...
    'FaceColor',[0.6,0.1,0.05]);
end

