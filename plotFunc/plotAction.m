function plotAction(link,xpos,ypos,radius)
%PLOTACTION Fonction permettant de pr�senter l'actionneur lin�aire
%   Il est possible avec cette fonction de faire monter et descendre la
%   hauteur de l'actionneur lin�aire en fonction de la lame sur le dessus.

% Actionneur lin�aire
[X,Y,Z] = cylinder(radius,50);
surf(link,X+xpos,Y+ypos,Z,'EdgeColor',[0.7,0.5,0.5],'FaceColor',...
    [0.6,0.1,0.05]);
end

