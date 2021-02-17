function loadAllConfigNames(app)
%LOADCONFIG Summary of this function goes here
%   Detailed explanation goes here
files = dir('.\config\*.mat');
index = 1;
for file = files'
    % Populate configuration history
    app.HistoriquedesconfigurationsListBox.Items(index) = {file.name};
    index = index + 1;
end
end

