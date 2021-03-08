function plotCash(link,num)
%PLOTCASH Fonction permettant d'afficher le plateau ainsi que les pièces
%   On utilise cette fonction pour illustrer les pièces sélectionnées ainsi
%   que la nombre de ces dernières. Le plateau est fixé à la lame même en
%   mouvement. Le paramètre "currency" est un vecteur de 2 dimensions
%   (nb,type) qui comporte un nombre de pièces d'un type en particulier.

if num == 1
    rectangle(link,'Position',[action_mid_x,mid_y,action_width, ...
        0.5],'FaceColor',[0.6,0.6,0.6]);
elseif num == 2
elseif num == 3
elseif (num > 3) && (num < 7)
else
end

end

