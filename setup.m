%% Option pour utiliser un API de l'association américaine des numismates
% url = 'http://numismatics.org/search/apis/getNuds?';
% data = webread(url)

% Il faut utiliser des query interne de l'API au lien
% https://www.greekcoinage.org/nuds.html

%% Setup avec petite base de données Excel
addpath('Data');
cadCoinTable = readtable('weiCAD.xlsx');

% Extract all keys and all values from table
keys = table2array(cadCoinTable(:,{'Year'}));
values = table2array(cadCoinTable(:,{'x1cent','x5cent','x10cent',...
                    'x20cent','x25cent','x50cent','x1dol','x2dol'}));
                
minCADYear = keys(1,1);
maxCADYear = keys(end,1);

% Make maps to every types of mint possible (provided from excel file)
coinCADMap = containers.Map;

% Make master map to bind
for key=1:length(keys)
    coinCADMap(int2str(keys(key,1))) = containers.Map({'1cent','5cent'...
        '10cent','20cent','25cent','50cent','1dol','2dol'},values(key,:));
end

% Clean-up miscellaneous values
clear keys values key cadCoinTable

% Bind values to mainCAO app
app.coinCADMap = coinCADMap;
app.minCADYear = minCADYear;
app.maxCADYear = maxCADYear;