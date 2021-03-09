function loadConfig(app,filename)
%LOADCONFIG Summary of this function goes here
%   Detailed explanation goes here
    % Extract data from selected config file
    
% Load all data from this specific filename
load(".\config\"+filename,'dimensionStruct','lameflexStruct','captStruct',...
    'timeStruct','actionStruct');

% Extract structs from newly loaded data
app.dimensionStruct = dimensionStruct;
app.lameflexStruct = lameflexStruct;
app.captStruct = captStruct;
app.timeStruct = timeStruct;
app.actionStruct = actionStruct;

% Clear remaining variables introduced by load
clear dimensionStruct lameflexStruct captStruct timeStruct actionStruct
end

