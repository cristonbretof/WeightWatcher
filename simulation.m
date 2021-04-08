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
[row,col] = size(app.simulCellArray);
for i=1:row
    if strcmp(app.simulCellArray{i,3},"Aucune")
        msg = "Un des évènements ajoutés n'est pas lié à une pièce";
        return;
    end
end

% Check if balayage is enabled
[row,col] = size(app.balayageCellArray);
if app.balayageEnabled
    if (row == 1) && (strcmp(app.balayageCellArray{1,1},"Aucun"))
        msg = "Aucun élément permettant de faire un balayage";
        return;
    end
end
% Open simulation
% model = 'simulateur';
% open_system(model);

% Create an input object
% simIn = Simulink.SimulationInput('simulateur');
% simIn = simIn.setVariable('len_lame',app.lameflexStruct.length,...
%                           'mass_lame',app.lameflexStruct.mass);
% simIn
% simOut = parsim(in);
sign = -1;
app.LameArray = zeros(1,(app.lameflexStruct.length-1)+1);
for j=1:100
    pause(0.0001)
    if ~mod(j,25)
        sign = sign*(-1);
    end
    for k=2:length(app.LameArray)
        app.LameArray(k) = app.LameArray(k)+sign*k*0.0015;
        if app.stopSim
            return;
        end
    end
    plotBase(app.UIAnim,app.lameflexStruct.length,app.dimensionStruct.height, ...
                app.dimensionStruct.pos_act,app.actionStruct.radius, ...
                app.LameArray,app.lameflexStruct.length, ...
                app.lameflexStruct.length/4,app.captStruct.spacing/2);
    close all
end
ret = 1;
% save("output.mat",'simOut');
end