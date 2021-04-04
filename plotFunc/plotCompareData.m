function plotCompareData(handle,x_axis,x_label,y_axis_1,y_axis_2,y_label,tag_1,tag_2)
%PLOT2DDATA Summary of this function goes here
%   Detailed explanation goes here

hold on
plot(handle, x_axis, y_axis_1, x_axis, y_axis_2);
xlabel(x_label);
ylabel(y_label);
legend(tag_1,tag_2);
hold off
end

