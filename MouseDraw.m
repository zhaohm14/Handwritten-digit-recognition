function  MouseDraw(action)
% ---------------------
% 改编自原作者：美利坚节度使 
% 来源：CSDN 
% 原文：https://blog.csdn.net/ying86615791/article/details/53607106?utm_source=copy

global InitialX InitialY FigHandle;
imSize = 28;
if nargin == 0
 action = 'start';
end
addpath(genpath(pwd));
 
switch(action)
    %%开启图形视窗
    case 'start',
        FigHandle = figure('WindowButtonDownFcn', 'MouseDraw down');
        set(FigHandle, 'Unit', 'pixel', 'Position', [0, 0, 270, 270], 'Resize', 'off');
        movegui(FigHandle, 'center');
        axis([1, imSize, 1, imSize]);    % 设定图轴范围
        grid off;
        box on;     % 将图轴加上图框
        set(gca, 'XTick', [], 'YTick', []);
        title('HandwritingRecognition');
    %%滑鼠按钮被按下时的反应指令
    case 'down',
        if strcmp(get(FigHandle, 'SelectionType'), 'normal')    %如果是左键
            set(FigHandle, 'pointer', 'hand');      
            CurPiont = get(gca, 'CurrentPoint');
            InitialX = CurPiont(1, 1);
            InitialY = CurPiont(1, 2);
            tic;
            % 设定滑鼠移动时的反应指令为「MouseDraw move」
            set(gcf, 'WindowButtonMotionFcn', 'MouseDraw move');
            set(gcf, 'WindowButtonUpFcn', 'MouseDraw up');
        elseif strcmp(get(FigHandle, 'SelectionType'), 'alt')   % 如果是右键
            set(FigHandle, 'Pointer', 'arrow');
            set(FigHandle, 'WindowButtonMotionFcn', '')
            set(FigHandle, 'WindowButtonUpFcn', '')

            InputImage = getframe(gca);
            Image = double(rgb2gray(InputImage.cdata));
            Image = 255 - Image(2 : size(Image, 1) - 1, 2 : size(Image, 2) - 1);
            [num, cfd] = HandwritingRecognition(Image); %%手写体识别
            mymsgbox({['Recognition result：', num2str(num)]; ['Confidence：', num2str(100 * cfd), '%']}, 'Recognition result');
            cla(gca);       %删除坐标图像
        end
    %%滑鼠移动时的反应指令
    case 'move',
        CurPiont = get(gca, 'CurrentPoint');
        X = CurPiont(1,1);
        Y = CurPiont(1,2);
        dis = norm([X - InitialX; Y - InitialY]);
        time = toc;
        pointNum = ceil(20 * dis * time);
        lineX = linspace(InitialX, X, pointNum);
        lineY = linspace(InitialY, Y, pointNum);
        line(lineX, lineY, 'marker', '.', 'markerSize', 50, 'Color', 'Black');
        InitialX = X;       %记住当前点坐标
        InitialY = Y;       %记住当前点坐标
    %%滑鼠按钮被释放时的反应指令
    case 'up',
        % 清除滑鼠移动时的反应指令
        set(gcf, 'WindowButtonMotionFcn', '');
        % 清除滑鼠按钮被释放时的反应指令
        set(gcf, 'WindowButtonUpFcn', '');
end
