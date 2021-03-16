function saveConfig(app)
%SAVECONFIG Summary of this function goes here
%   Detailed explanation goes here
formatOut = 'yyyymmdd_HH-MM-SS';
date_time = datestr(now,formatOut);
path = ".\config\"+date_time+".mat";

dimensionStruct = app.dimensionStruct;
lameflexStruct = app.lameflexStruct;
captStruct = app.captStruct;
timeStruct = app.timeStruct;
actionStruct = app.actionStruct;
coinCellArray = app.coinCellArray;
simulCellArray = app.simulCellArray;
save(path,'dimensionStruct','lameflexStruct',...
    'captStruct','timeStruct','actionStruct','coinCellArray',...
    'simulCellArray');

% Clear remaining variables introduced by load
clear dimensionStruct lameflexStruct captStruct timeStruct actionStruct ...
    coinCellArray simulCellArray
end

