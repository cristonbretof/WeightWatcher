function writeLogError(link,log)
%WRITELOGERROR Fonction permettant d'afficher un message de log
%   Detailed explanation goes here
    set(link.LogTextArea,'FontColor','red');
    new_log = append("[ERROR]: ",log);
    set(link.LogTextArea,'Value',link.LogTextArea.Value + new_log);
end