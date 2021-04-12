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

mass_event_time = zeros(1,app.timeStruct.num_samples);

total_mass = 0;

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

% Set global Simulink configurations (timing and such)
set_param('simulateur_final','StopTime',num2str(app.timeStruct.duration*app.timeStruct.num_samples));
set_param('simulateur_final','FixedStep',num2str(app.timeStruct.duration));

% Set parameters within constants in the simulator

% Lame configurations
set_param('simulateur_final/dt','Value',num2str(app.timeStruct.duration));
set_param('simulateur_final/d_lame','Value',num2str(app.lameflexStruct.thick));
set_param('simulateur_final/t_lame','Value',num2str(app.lameflexStruct.width));
set_param('simulateur_final/L_lame','Value',num2str(app.lameflexStruct.length));
set_param('simulateur_final/E','Value',num2str(app.lameflexStruct.E));
set_param('simulateur_final/J','Value',num2str(app.lameflexStruct.J));
set_param('simulateur_final/masse_lame','Value',num2str(app.lameflexStruct.mass));
set_param('simulateur_final/masse_action','Value',num2str(app.actionStruct.m));
set_param('simulateur_final/Gamma','Value',num2str(app.lameflexStruct.Att));
set_param('simulateur_final/dens','Value',num2str(app.lameflexStruct.mu));
set_param('simulateur_final/wn','Value',num2str(app.lameflexStruct.wn));
set_param('simulateur_final/pos_act','Value',num2str(app.dimensionStruct.pos_act));
set_param('simulateur_final/pos_obj','Value',num2str(app.dimensionStruct.pos_act));

% Position detector configurations
set_param('simulateur_final/Vim','Value',num2str(app.captStruct.Vim));
set_param('simulateur_final/e_0','Value',num2str(app.captStruct.spacing/2));
set_param('simulateur_final/G1','Value','125');
set_param('simulateur_final/G2','Value','0.6');
set_param('simulateur_final/Vth','Value',num2str(app.captStruct.Vth));

% PID configurations
set_param('simulateur_final/Kp','Value',num2str(app.captStruct.Kp));
set_param('simulateur_final/Ki','Value',num2str(app.captStruct.Ki));
set_param('simulateur_final/Kd','Value',num2str(app.captStruct.Kd));
set_param('simulateur_final/v0','Value','2.5');

% Amplifier configurations
set_param('simulateur_final/Amplificateur','Gain', ...
    num2str(app.dimensionStruct.gain_ampli));

% Save mass array to input in lame model
save("simu_input_data.mat",'mass_event_time');

% Create an input object
% simIn = Simulink.SimulationInput('simulateur_final');
simOut = sim('simulateur_final');

% Open simulation
% model = 'simulateur_final';
% open_system(model, 'loadonly');

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
%             tag = 
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
% end


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
ret = 1;
save("output.mat",'simOut');

end