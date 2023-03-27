% 从图片中选择并导入
[filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg,*.jpeg,*.png,*.bmp)'}, 'Select Image File');
img = imread(fullfile(filepath, filename));

% 转换为灰度图像
gray_img = rgb2gray(img);

% 边缘检测
edge_img = edge(gray_img,'Canny');

% 霍夫变换提取直线
[H,T,R] = hough(edge_img);
P = houghpeaks(H,20);
lines = houghlines(edge_img,T,R,P,'FillGap',100,'MinLength',80);
% 从直线中筛选坐标轴和曲线
x_axis_line = [];
y_axis_line = [];
curve_lines = [];
for i = 1:length(lines)
    angle = abs(lines(i).theta);
    if isempty(angle)
        continue;
    end
    rho = abs(lines(i).rho);
    if angle < 15
        x_axis_line = lines(i);
    elseif angle > 60
        y_axis_line = lines(i);
    else
        curve_lines = [curve_lines; lines(i)];
    end
end

% 显示筛选后的坐标轴和曲线
figure;
imshow(img);
hold on;
if ~isempty(x_axis_line)
    xy = [x_axis_line.point1; x_axis_line.point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
if ~isempty(y_axis_line)
    xy = [y_axis_line.point1; y_axis_line.point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
end
for i = 1:length(curve_lines)
    xy = [curve_lines(i).point1; curve_lines(i).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
end

% 标记曲线
if ~isempty(curve_lines)
    xy = [curve_lines(1).point1; curve_lines(1).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','yellow');
end

% 在曲线上采样
curve_xy = [];
for i = 1:length(curve_lines)
    xy = [curve_lines(i).point1; curve_lines(i).point2];
    [x, y] = get_curve_samples(xy, 100);
    curve_xy = [curve_xy; [x y]];
end
% 获取曲线上点对应的X轴和Y轴坐标
x_axis_rho = abs(x_axis_line.rho);
y_axis_rho = abs(y_axis_line.rho);
x_points = [];
y_points = [];
for i = 1:size(curve_xy,1)
x = curve_xy(i,1);
y = curve_xy(i,2);
x_rho = xcosd(x_axis_line.theta) + ysind(x_axis_line.theta);
y_rho = xcosd(y_axis_line.theta) + ysind(y_axis_line.theta);
x_axis_dist = abs(x_rho - x_axis_rho);
y_axis_dist = abs(y_rho - y_axis_rho);
if x_axis_dist <= y_axis_dist
x_points = [x_points; [x, x_rho]];
else
y_points = [y_points; [y_rho, y]];
end
end

% 输出 x_points 变量信息
disp('x_points:');
disp(x_points);

% 输出 y_points 变量信息
disp('y_points:');
disp(y_points);



% 这个是测试行
% 再测试一行
