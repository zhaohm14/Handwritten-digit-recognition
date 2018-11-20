function  MouseDraw(action)
% ---------------------
% �ı���ԭ���ߣ�������ڶ�ʹ 
% ��Դ��CSDN 
% ԭ�ģ�https://blog.csdn.net/ying86615791/article/details/53607106?utm_source=copy

global InitialX InitialY FigHandle;
imSize = 28;
if nargin == 0
 action = 'start';
end
addpath(genpath(pwd));
 
switch(action)
    %%����ͼ���Ӵ�
    case 'start',
        FigHandle = figure('WindowButtonDownFcn', 'MouseDraw down');
        set(FigHandle, 'Unit', 'pixel', 'Position', [0, 0, 270, 270], 'Resize', 'off');
        movegui(FigHandle, 'center');
        axis([1, imSize, 1, imSize]);    % �趨ͼ�᷶Χ
        grid off;
        box on;     % ��ͼ�����ͼ��
        set(gca, 'XTick', [], 'YTick', []);
        title('HandwritingRecognition');
    %%����ť������ʱ�ķ�Ӧָ��
    case 'down',
        if strcmp(get(FigHandle, 'SelectionType'), 'normal')    %��������
            set(FigHandle, 'pointer', 'hand');      
            CurPiont = get(gca, 'CurrentPoint');
            InitialX = CurPiont(1, 1);
            InitialY = CurPiont(1, 2);
            tic;
            % �趨�����ƶ�ʱ�ķ�Ӧָ��Ϊ��MouseDraw move��
            set(gcf, 'WindowButtonMotionFcn', 'MouseDraw move');
            set(gcf, 'WindowButtonUpFcn', 'MouseDraw up');
        elseif strcmp(get(FigHandle, 'SelectionType'), 'alt')   % ������Ҽ�
            set(FigHandle, 'Pointer', 'arrow');
            set(FigHandle, 'WindowButtonMotionFcn', '')
            set(FigHandle, 'WindowButtonUpFcn', '')

            InputImage = getframe(gca);
            Image = double(rgb2gray(InputImage.cdata));
            Image = 255 - Image(2 : size(Image, 1) - 1, 2 : size(Image, 2) - 1);
            [num, cfd] = HandwritingRecognition(Image); %%��д��ʶ��
            mymsgbox({['Recognition result��', num2str(num)]; ['Confidence��', num2str(100 * cfd), '%']}, 'Recognition result');
            cla(gca);       %ɾ������ͼ��
        end
    %%�����ƶ�ʱ�ķ�Ӧָ��
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
        InitialX = X;       %��ס��ǰ������
        InitialY = Y;       %��ס��ǰ������
    %%����ť���ͷ�ʱ�ķ�Ӧָ��
    case 'up',
        % ��������ƶ�ʱ�ķ�Ӧָ��
        set(gcf, 'WindowButtonMotionFcn', '');
        % �������ť���ͷ�ʱ�ķ�Ӧָ��
        set(gcf, 'WindowButtonUpFcn', '');
end
