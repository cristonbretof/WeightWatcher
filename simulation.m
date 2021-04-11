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
[simu_row,col] = size(app.simulCellArray);
for i=1:simu_row
    if strcmp(app.simulCellArray{i,3},"Aucune")
        msg = "Un des évènements ajoutés n'est pas lié à une pièce";
        return;
    end
end

app.timeStruct.num_samples
app.timeStruct.duration

mass_event_time = zeros(1,app.timeStruct.num_samples);
% n_mass_event_time = 0:

total_mass = 0;
mass_index = 0;

evt = 1;
elapsed_time = 0;
for i=1:app.timeStruct.num_samples
    if evt > simu_row
        break;
    end
    if elapsed_time == app.simulCellArray{evt,1}/1000
        if strcmp(app.simulCellArray{evt,2},"Ajouter")
            total_mass = total_mass + ...
                app.coinCellArray{str2double(app.simulCellArray{evt,3}),3} * ...
                app.coinCellArray{str2double(app.simulCellArray{evt,3}),5};
        elseif strcmp(app.simulCellArray{evt,2},"Retirer")
            if total_mass - app.coinCellArray{str2double(app.simulCellArray{evt,3}),5} < 0
                msg = "La suite d'évènement est invalide (une masse négative est sur la balance)";
                return;
            else
                total_mass = total_mass - ...
                    app.coinCellArray{str2double(app.simulCellArray{evt,3}),3} * ...
                    app.coinCellArray{str2double(app.simulCellArray{evt,3}),5};
            end
        end
        evt = evt + 1;
    end
    mass_event_time(i) = total_mass;
    elapsed_time = i*app.timeStruct.duration;
end

set_param('simulateur_final','StopTime',num2str(app.timeStruct.duration*app.timeStruct.num_samples));
set_param('simulateur_final','FixedStep',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));


% Open simulation
% model = 'simulateur_final';
% open_system(model, 'loadonly');
% 
% save("simu_input_data.mat");
% 
% clear 

% busInfo = Simulink.Bus.createObject(baseStruct);
% busInfo
% Check if balayage is enabled
% [row,col] = size(app.balayageCellArray);
% if app.balayageEnabled
%     if (row == 1) && (strcmp(app.balayageCellArray{1,1},"Aucun"))
%         msg = "Aucun élément permettant de faire un balayage";
%         return;
%     end
%     for i=1:row
%         if strcmp(app.balayageCellArray{i,1},"Aucun")
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Position du plateau")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Longueur de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Largeur de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Épaisseur de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Masse de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante b de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Module de Young E")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Moment daire J")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Atténuation de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Fréquence naturelle de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Densité de masse de la lame")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Rayon de la bobine")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Hauteur de la bobine")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Diamètre des spires")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Inductance L de lactionneur")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Nombre de spires")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Perméabilité relative de la bobine")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Kp du PID")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Ki du PID")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Kd du PID")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Tension Vim du capteur de position")
%             b_index = b_index + 1;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Tension Vth du capteur de position")
%             b_index = b_index + 1;
%         end
%     end
% end

% Open simulation
% model = 'simulateur';
% open_system(model);

% Create an input object
% simIn = Simulink.SimulationInput('simulateur');
% simIn = simIn.setVariable('len_lame',app.lameflexStruct.length,...
%                           'mass_lame',app.lameflexStruct.mass);
% simIn
% simOut = parsim(in);
% sign = -1;
% app.LameArray = zeros(1,(app.lameflexStruct.length-1)+1);
% for j=1:100
%     pause(0.0001)
%     if ~mod(j,25)
%         sign = sign*(-1);
%     end
%     for k=2:length(app.LameArray)
%         app.LameArray(k) = app.LameArray(k)+sign*k*0.0015;
%         if app.stopSim
%             return;
%         end
%     end
%     plotBase(app.UIAnim,app.lameflexStruct.length,app.dimensionStruct.height, ...
%                 app.dimensionStruct.pos_act,app.actionStruct.radius, ...
%                 app.LameArray,app.lameflexStruct.length, ...
%                 app.lameflexStruct.length/4,app.captStruct.spacing/2);
%     close all
% end
% ret = 1;
% save("output.mat",'simOut');

end