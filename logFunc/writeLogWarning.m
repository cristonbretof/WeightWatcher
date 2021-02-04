function writeLogWarning(link,log)
%WRITELOGWARNING Fonction permettant d'afficher un message de log
%   Detailed explanation goes here
    set(link.LogTextArea,'FontColor','orange');
    new_log = append("[WARNING]: ",log);
    set(link.LogTextArea,'Value',new_log);
end

