function [ret, msg] = simulation(app)
%SIMULATION Summary of this function goes here
%   Detailed explanation goes here
ret = 0;
msg = "Success";

% Validate if correct timewise configurations
if (app.timeStruct.num_samples == 0) || (app.timeStruct.duration == 0)
    msg = "Nombre d'échantillons ou temps par échantillons invalides";
    return;
end

% Check if coin cell array is empty
if isempty(app.coinCellArray)
    msg = "Aucune pièce n'a été ajouté à la simulation";
    return;
end

% Check if event cell array is empty
if isempty(app.simulCellArray)
    msg = "Aucun évènement n'a été ajouté à la simulation";
    return;
end

simOut = parsim('simulateur.slx','struct');

ret = 1;

if ~app.balayageEnabled
    while doRun == 1
        pause(app.timeStruct.duration);
        plotBase(app.UIAnim,simOut.wn)
    end
end
save("output.mat",'simOut');
end