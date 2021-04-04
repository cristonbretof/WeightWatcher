function [ret, msg] = simulation(app)
%SIMULATION Summary of this function goes here
%   Detailed explanation goes here
ret = 0;
msg = "Success";

% Validate if correct timewise configurations
if (app.timeStruct.num_samples == 0) || (app.timeStruct.duration == 0)
    msg = "Nombre d'�chantillons ou temps par �chantillons invalides";
    return;
end

% Check if coin cell array is empty
if isempty(app.coinCellArray)
    msg = "Aucune pi�ce n'a �t� ajout� � la simulation";
    return;
end

% Check if event cell array is empty
if isempty(app.simulCellArray)
    msg = "Aucun �v�nement n'a �t� ajout� � la simulation";
    return;
end



ret = 1;
end