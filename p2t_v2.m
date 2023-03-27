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
function [x_points, y_points] = p2t_v2(filename)
% P2T_V2 extract data points from image
%   [x_points, y_points] = P2T_V2(filename) reads in the image specified by
%   filename, detects the axis lines, and extracts data points from the
%   image. The x_points and y_points are returned as output.

    % Read in image
    I = imread(filename);

    % Detect axis lines
    [x_axis_line, y_axis_line] = detect_axis_lines(I);

    % Define output arrays
    x_points = [];
    y_points = [];

    % Extract data points
    for i = 1:size(curve_lines,2)
        curve_lines(i).points = get_points_on_line(curve_lines(i).line, I);
    end

    % Plot axis lines and data points
    figure;
    imshow(I);
    hold on;
    if ~isempty(x_axis_line)
        xy = [x_axis_line.point1; x_axis_line.point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    end
    if ~isempty(y_axis_line)
        xy = [y_axis_line.point1; y_axis_line.point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
    end
    for i = 1:size(curve_lines,2)
        if ~isempty(curve_lines(i).points)
            plot(curve_lines(i).points(:,1), curve_lines(i).points(:,2), 'LineWidth',2,'Color','blue');
        end
    end
    hold off;
end

function [x_axis_line, y_axis_line] = detect_axis_lines(I)
    % ... function body here ...
end

function points = get_points_on_line(line, I)
    % ... function body here ...
end

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

