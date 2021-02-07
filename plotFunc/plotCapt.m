function plotCapt(link,total_width,total_height,fixbar_height,type)
%PLOTCAPT Fonction permettant d'afficher le capteur choisi sur le montage
%   On utilise cette fonction pour ajouter le capteur sur le montage du
%   prototype (en simulation) tout en gardant l'abstraction venant de la
%   sélection du capteur.

base_height = 0.1*total_height; % Hauteur de la base

if type == "Capacitive"

% Électrode inférieure du capteur
rectangle(link,'Position',[0.75*total_width,0.9*(base_height+fixbar_height), ...
    0.25*total_width,0.1*base_height],'FaceColor',[0.7,0.2,0.05]);
rectangle(link,'Position',[0.75*total_width,(base_height+fixbar_height), ...
    0.25*total_width,0.1*base_height],'FaceColor',[0.7,0.2,0.05]);
elseif type == "Magnetic"
    error("Erreur: Capteur magnetique non implanté (plotCapt)");
elseif type == "Ultrasonic"
    error("Erreur: Capteur ultrasonique non implanté (plotCapt)");
else
    error("Erreur: Type de capteur invalide (plotCapt)");
end

end

