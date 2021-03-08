%% Option pour utiliser un API de l'association américaine des numismates

% url = "http://numismatics.org/search/id/"+"0000.999.32873"+".ttl";
% data = webread(url)
% 
% weight_index = strfind(data,'hasWeight')+length('hasWeight')+2
% data(weight_index:end)
% title_index = strfind(data,'title')+length('title')+2
% data(title_index:end)
% year_index = strfind(data,' - ')-4
% data(year_index:end)



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
    coinCADMap(int2str(keys(key,1))) = struct('x1cent',values(key,1),...
        'x5cent',values(key,2),'x10cent',values(key,3),'x20cent',...
        values(key,4),'x25cent',values(key,5),'x50cent',values(key,6),...
        'x1dol',values(key,7),'x2dol',values(key,8));
end

% Clean-up miscellaneous values
clear keys values key cadCoinTable

% Bind values to mainCAO app
app.coinCADMap = coinCADMap
app.minCADYear = minCADYear
app.maxCADYear = maxCADYear