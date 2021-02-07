function writeLogInfo(link,log)
%WRITELOGINFO Fonction permettant d'afficher un message de log
%   Detailed explanation goes here
    set(link.LogTextArea,'FontColor','black');
    new_log = append("[INFO]: ",log);
    set(link.LogTextArea,'Value',link.LogTextArea.Value + new_log);
end

