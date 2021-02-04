%% Option pour utiliser un API de l'association américaine des numismates
% url = 'http://numismatics.org/search/apis/getNuds?';
% data = webread(url)

% Il faut utiliser des query interne de l'API au lien
% https://www.greekcoinage.org/nuds.html

%% Setup avec petite base de données Excel
addpath('Data');
cadCoinTable = readtable('weiCAD.xlsx');

cadCoinTable({'1919'},:)