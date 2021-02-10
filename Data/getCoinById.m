function [title,region,weight,year] = getCoinById(app,identifier,varargin)
%GETCOINBYID Summary of this function goes here
%   Detailed explanation goes here
url = "http://numismatics.org/search/id/"+identifier+".ttl";

try
    data = webread(url);
catch
    title="";region="";weight=0;year="";
    return
end

weight_index = strfind(data,'hasWeight')+length('hasWeight')+2;
title_index = strfind(data,'title')+length('title')+2;
year_index = strfind(data,' - ')-4;

weight_data = "";
title_data = "";
year_data = "";
region_data = "";

w_char = '';
r_char = '';
t_char = '';
y_char = '';

temp_index = 0;
while ~strcmp(w_char,'"')
    weight_data = weight_data + w_char;
    w_char = data(1,weight_index + temp_index);
    temp_index = temp_index + 1;
end
temp_index = 0;
while ~strcmp(t_char,',')
    title_data = title_data + t_char;
    t_char = data(1,title_index + temp_index);
    temp_index = temp_index + 1;
end
while ~strcmp(r_char,',')
    region_data = region_data + r_char;
    r_char = data(1,title_index + temp_index + 1);
    temp_index = temp_index + 1;
end
temp_index = 0;
while ~strcmp(y_char,'.')
    year_data = year_data + y_char;
    y_char = data(1,year_index + temp_index);
    temp_index = temp_index + 1;
end

weight = str2double(weight_data);
title = title_data;
region = region_data;
year = year_data;

end

