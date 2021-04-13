function [ret, msg] = simulation(app)
%SIMULATION Summary of this function goes here
%   Detailed explanation goes here
clc
clear 'out'

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

app.Lamp.Color = 'blue';
app.AmorcerlasimulationButton.Text = "En attente...";
mass_event_time = zeros(1,app.timeStruct.num_samples);
n_mass_event_time = 0:app.timeStruct.duration:(app.timeStruct.num_samples-1)*...
    app.timeStruct.duration;

total_mass = 0;

% Build mass vector to feed dynamic mass in Simulink
evt = 1;
elapsed_time = 0;
for i=1:app.timeStruct.num_samples
    if evt > simu_row
        break;
    end
    if elapsed_time == app.simulCellArray{evt,1}/1000000
        if strcmp(app.simulCellArray{evt,2},"Ajouter")
            total_mass = total_mass + ...
                app.coinCellArray{str2double(app.simulCellArray{evt,3}),3} * ...
                (app.coinCellArray{str2double(app.simulCellArray{evt,3}),5}/1000);
        elseif strcmp(app.simulCellArray{evt,2},"Retirer")
            if total_mass - app.coinCellArray{str2double(app.simulCellArray{evt,3}),3}* ...
                    (app.coinCellArray{str2double(app.simulCellArray{evt,3}),5}/1000) < 0
                msg = "La suite d'évènement est invalide (une masse négative est sur la balance)";
                return;
            else
                total_mass = total_mass - ...
                    app.coinCellArray{str2double(app.simulCellArray{evt,3}),3} * ...
                    (app.coinCellArray{str2double(app.simulCellArray{evt,3}),5}/1000);
            end
        end
        evt = evt + 1;
    end
    mass_event_time(i) = total_mass;
    elapsed_time = i*app.timeStruct.duration;
end

% Load block diagram
load_system('simulateur');

% Set global Simulink configurations (timing and such)
set_param('simulateur','StopTime',num2str(app.timeStruct.duration*app.timeStruct.num_samples));
set_param('simulateur','FixedStep',num2str(app.timeStruct.duration));

% Set parameters within constants in the simulator
% Lame configurations
set_param('simulateur/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur/d_lame','Value',num2str(app.lameflexStruct.thick));
set_param('simulateur/t_lame','Value',num2str(app.lameflexStruct.width));
set_param('simulateur/L_lame','Value',num2str(app.lameflexStruct.length));
set_param('simulateur/E','Value',num2str(app.lameflexStruct.E));
set_param('simulateur/J','Value',num2str(app.lameflexStruct.J));
set_param('simulateur/masse_lame','Value',num2str(app.lameflexStruct.mass));
set_param('simulateur/masse_action','Value',num2str(app.actionStruct.m));
set_param('simulateur/Gamma','Value',num2str(app.lameflexStruct.Att));
set_param('simulateur/dens','Value',num2str(app.lameflexStruct.mu));
set_param('simulateur/wn','Value',num2str(app.lameflexStruct.wn));
set_param('simulateur/pos_act','Value',num2str(app.dimensionStruct.pos_act));
set_param('simulateur/pos_obj','Value',num2str(app.dimensionStruct.pos_act));

% Position detector configurations
set_param('simulateur/Vim','Value',num2str(app.captStruct.Vim));
set_param('simulateur/e_0','Value',num2str(app.captStruct.spacing/2));
set_param('simulateur/G1','Value','125');
set_param('simulateur/G2','Value','0.6');
set_param('simulateur/Vth','Value',num2str(app.captStruct.Vth));

% PID configurations
set_param('simulateur/Kp','Value',num2str(app.captStruct.Kp));
set_param('simulateur/Ki','Value',num2str(app.captStruct.Ki));
set_param('simulateur/Kd','Value',num2str(app.captStruct.Kd));
set_param('simulateur/v0','Value','2.5');

% Amplifier configurations
set_param('simulateur/Amplificateur','Gain', ...
    num2str(app.dimensionStruct.gain_ampli));

ret = 1;

% Save mass array to input in lame model
assignin('base','simin',timeseries(mass_event_time,n_mass_event_time));
% set_param('simulateur/input_mass','Data','mass_event_time');

model = 'simulateur';
simOut = sim(model, 'timeout', 60);

% Create an input object
% simIn = Simulink.SimulationInput('simulateur_final');
if ~app.balayageEnabled
    app.Lamp.Color = 'red';
    app.AmorcerlasimulationButton.Text = "Arreter l'animation";
    for i=1:length(simOut.lame.Data)
        plotBase(app.UIAnim,app.lameflexStruct.length*100,app.dimensionStruct.height*100, ...
            app.dimensionStruct.pos_act*100,app.actionStruct.radius*100,simOut.lame.Data(:,:,i), ...
            app.lameflexStruct.length*100,app.dimensionStruct.length*25,...
            app.captStruct.spacing*200);
        close all
        if app.stopSim
            return;
        end
    end
    ret = 1;
else
    msg = "Le balayage n'est pas supporté pour l'instant...";
    return;
end

% Print all samples to plots
plot2DData(app.MasseAxes,simOut.masse_finale.Tout,simOut.masse_finale.Data);
plot2DData(app.PositionAxes,simOut.w_out.Tout,simOut.w_out.Data);

% if (row == 1) && (strcmp(app.balayageCellArray{1,1},"Aucun"))
%         msg = "Aucun élément permettant de faire un balayage";
%         return;
%     end
%     for i=1:row
%         if strcmp(app.balayageCellArray{i,1},"Aucun")
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Position du plateau")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Longueur de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Largeur de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Épaisseur de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Masse de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante b de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Module de Young E")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Moment daire J")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Atténuation de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Fréquence naturelle de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Densité de masse de la lame")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Rayon de la bobine")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Hauteur de la bobine")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Diamètre des spires")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Inductance L de lactionneur")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Nombre de spires")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Perméabilité relative de la bobine")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Champs magnétique B")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Kp du PID")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Ki du PID")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Constante Kd du PID")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Tension Vim du capteur de position")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%         if strcmp(app.balayageCellArray{i,1},"Tension Vth du capteur de position")
%             legend_tag = app.balayageCellArray{i,1};
%             parsim_array = app.balayageCellArray{i,2}: ...
%                 app.balayageCellArray{i,3}:app.balayageCellArray{i,4};
%             numSims = length(parsim_array);
%             break;
%         end
%     end
%     for i=numSims:-1:1
%         in(i) = Simulink.SimulationInput('simulateur_final');
%         in(i) = setVariable(in(i),tag,relSlip_vals(i));
%     end

% Open simulation
% model = 'simulateur_final';

% Open simulation
% model = 'simulateur';
% open_system(model);
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

end