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
allParamNames = app.allParametersCellArray;
dropDownCoinList = app.dropDownCoinList;
balayageCellArray = app.balayageCellArray;

save(path,'dimensionStruct','lameflexStruct',...
    'captStruct','timeStruct','actionStruct','coinCellArray',...
    'simulCellArray','dropDownCoinList','allParamNames','balayageCellArray');

% Clear remaining variables introduced by load
clear dimensionStruct lameflexStruct captStruct timeStruct actionStruct ...
    coinCellArray simulCellArray allParamNames dropDownCoinList balayageCellArray
end

