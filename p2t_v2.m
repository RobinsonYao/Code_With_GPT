function p2t_v1(img)
% P2T_V1 Point-to-line intersection for xy curves.

clc; clear all; close all;

% Load image
if nargin < 1
    [FileName,PathName,~] = uigetfile({'*.bmp;*.png;*.jpg;*.tif'},'Select a Image file');
    img = fullfile(PathName, FileName);
end
I = imread(img);
figure; imshow(I);

% Get xy curves
figure;
imshow(I);
curve_lines = drawfreehand('LineWidth',2,'Color','magenta','Closed',false);
curve_xy = curve_lines.Position;

% Get axis lines
[x_axis_line, y_axis_line] = get_axis_lines(I);

% Find intersection points
x_points = [];
y_points = [];

if ~isempty(x_axis_line) && ~isempty(y_axis_line)
    for i = 1:size(curve_xy,1)
        x = curve_xy(i,1);
        y = curve_xy(i,2);
        x_rho = xcosd(x_axis_line.theta) + ysind(x_axis_line.theta);
        y_rho = xcosd(y_axis_line.theta) + ysind(y_axis_line.theta);
        x_axis_dist = abs(x_rho - x_axis_line.rho);
        y_axis_dist = abs(y_rho - y_axis_line.rho);
        if x_axis_dist <= y_axis_dist
            x_points = [x_points; [x, x_rho]];
        else
            y_points = [y_points; [y_rho, y]];
        end
    end
else
    disp('No axis lines found!');
end

if isempty(x_points) && isempty(y_points)
    disp('No intersection points found!');
else
    disp('x_points:');
    disp(x_points);
    disp('y_points:');
    disp(y_points);
end
end

