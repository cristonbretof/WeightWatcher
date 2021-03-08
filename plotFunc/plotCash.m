function plotCash(link,num)
%PLOTCASH Fonction permettant d'afficher le plateau ainsi que les pi�ces
%   On utilise cette fonction pour illustrer les pi�ces s�lectionn�es ainsi
%   que la nombre de ces derni�res. Le plateau est fix� � la lame m�me en
%   mouvement. Le param�tre "currency" est un vecteur de 2 dimensions
%   (nb,type) qui comporte un nombre de pi�ces d'un type en particulier.

if num == 1
    rectangle(link,'Position',[action_mid_x,mid_y,action_width, ...
        0.5],'FaceColor',[0.6,0.6,0.6]);
elseif num == 2
elseif num == 3
elseif (num > 3) && (num < 7)
else
end

end

