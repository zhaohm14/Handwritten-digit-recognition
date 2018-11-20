function mainFcn

%--------------------训练参数---------------------
global PrmStg;

totalStep = PrmStg.totalStep;                       %最大学习步数
m = PrmStg.m;                                     	%训练集数量
m_v = PrmStg.m_v;                                   %验证集数量
alpha = PrmStg.alphaDis;                            %学习率
lambda = PrmStg.lambda;                             %正则化惩罚
minibatch = PrmStg.minibatch;                       %每次迭代应用MINI Batch的样本数量
minAlpha = PrmStg.minAlpha;                         %收敛跳出判定比例
JReduceCheckStep = PrmStg.JReduceCheckStep;         %代价函数收敛判定的迭代步长间隔
accuracyAim = PrmStg.accuracyAim;               	%交叉验证集的准确率的预设目标
rateCheckStep = PrmStg.rateCheckStep;               %检查识别准确度的迭代步长间隔
saveStep = PrmStg.saveStep;                         %在迭代中保存数据的迭代次数间隔
GPUOpt = PrmStg.GPUOpt;                             %开启GPU加速的选项
coreNum = PrmStg.coreNum;                       	%使用的CPU核心数量
restartMode = PrmStg.restartMode;                   %值为'Resume'时将读取已有Theta数据续算，值为'Restart'时将进行随机初始化
rateCheckOpt = PrmStg.rateCheckOpt;                 %检查识别准确率的选项
%------------------------------------------------


%----------------------架构----------------------
global unit_net;
global sample_size_x sample_size_y
unit = [sample_size_x; unit_net; sample_size_y];    %各层神经网络的单元数（包括输入与输出，不包括偏置单元）
Layer = size(unit, 1) - 2;                          %获取神经网络层数
%------------------------------------------------


%----------------------样本----------------------
%训练集
global train_x train_y;
X = train_x(1 : m, :)';                             %输入特征
Y = train_y(1 : m, :)';                             %预测特征
%验证集
X_v = train_x(m + 1 : m + m_v, :)';
Y_v = train_y(m + 1 : m + m_v, :)';
%------------------------------------------------


%-------------------权重初始化--------------------
switch restartMode
    %---------------------使用已有权重进行初始化---------------------
    case 'Resume'
        Theta = myload('Theta.mat');

    %---------------------使用随机参数进行初始化---------------------
    case 'Restart'
        epsilon = PrmStg.epsilon;
        Theta = cell(1, Layer + 1);
        for ii = 1 : Layer + 1
            Theta{ii} = epsilon * (1 - 2 * rand(unit(ii + 1), unit(ii) + 1));
        end

end
%------------------------------------------------


%-------------------变量初始化--------------------
batchStart = 1;
rateNum = 0;
J_avg_0 = inf;
alphaAutoChangeNum = 0;
if totalStep == Inf
    defSize = 10^6;
else
    defSize = totalStep;
end
J = zeros(defSize, 1);
rateStep = zeros(ceil((defSize + 1)/ JReduceCheckStep) + 1, 1);
Rate = zeros(ceil((defSize + 1)/ JReduceCheckStep) + 1, 1);
Rate_v = zeros(ceil((defSize + 1)/ JReduceCheckStep) + 1, 1);
alphaAutoChangeStep = zeros(ceil(defSize / JReduceCheckStep), 1);
figure('Name', 'Monitoring window', 'NumberTitle', 'off');
if rateCheckOpt
    hAxes1 = subplot(2, 1, 1);
    hAxes2 = subplot(2, 1, 2);
else
    hAxes1 = subplot(1, 1, 1);
end


%--------------------运算加速---------------------
% GPU加速
if GPUOpt
    X = gpuArray(single(X));
    Y = gpuArray(single(Y));
    X_v = gpuArray(single(X_v));
    Y_v = gpuArray(single(Y_v));
    for ii = 1 : Layer + 1
        Theta{ii} = gpuArray(single(Theta{ii}));
    end
    J = gpuArray(single(J));
end

% 多线程
coreNumNow = matlabpool('size');
if coreNum <= 1 && coreNumNow
    matlabpool close;
elseif coreNumNow ~= coreNum
    matlabpool('open', 'local', coreNum);
end
coreNum = matlabpool('size');
%------------------------------------------------



%--------------------------------------------------------------------------
for step = 1 : totalStep
    disp(['step = ', num2str(step)]);
    if(step > 1)
        t = toc;
        disp(['上一步用时：', num2str(t), 's']);
    end
    tic;
    
    %计算识别准确率
    if rateCheckOpt
        if mod(step, rateCheckStep) == 1 || rateCheckStep == 1
            m_rp = randperm(m);
            m_v_rp = randperm(m_v);
            X_r = X(:, m_rp(1 : minibatch));
            Y_r = Y(:, m_rp(1 : minibatch));
            X_v_r = X_v(:, m_v_rp(1 : minibatch));
            Y_v_r = Y_v(:, m_v_rp(1 : minibatch));
            rate = acyRate(X_r, Y_r, Theta, minibatch);
            disp(['训练集识别准确率为:',num2str(rate * 100),'%']);
            rate_v = acyRate(X_v_r, Y_v_r, Theta, minibatch);
            disp(['验证集识别准确率为:',num2str(rate_v * 100),'%']);
            rateNum = rateNum + 1;
            rateStep(rateNum) = step;
            Rate(rateNum) = rate;
            Rate_v(rateNum) = rate_v;
            if rate_v > accuracyAim
                disp('验证集识别准确率已达到预设目标');
                break;
            end
        end
    end
    
    %初始化项
    sum_cost = 0;
    %对Δ进行初始化
    DeltaSize = zeros(Layer + 1, 2);
    DeltaLength = zeros(Layer + 1, 1);
    for ii = 1 : Layer + 1
        DeltaSize(ii, :) = [unit(ii + 1), unit(ii) + 1];
        DeltaLength(ii) = unit(ii + 1) * (unit(ii) + 1);
    end
    DeltaPos = [1, unit(2) * (unit(1) + 1); zeros(Layer, 2)];
    for ii = 2 : Layer + 1
        DeltaPos(ii, :) = DeltaPos(ii - 1, 2) + [1, DeltaLength(ii)];
    end
    
    DeltaLine = zeros(sum(DeltaLength), 1);
    if GPUOpt
        DeltaLine = gpuArray(single(DeltaLine));
    end
    
    %计算当前MINI Batch位置
    batchEnd = batchStart + minibatch;
    mb = batchStart : min(batchEnd, m);
    batchLength = length(mb);
    batchStart = mod(batchEnd, m);
    
    parfor samSrlNum = mb
        x = X(:, samSrlNum);
        y = Y(:, samSrlNum);
        
        %前向传播
        a = cell(1, Layer + 2);
        a{1} = [1; x];
        for ii = 2 : Layer + 1
            a{ii} = [1; sigmoid(Theta{ii - 1} * a{ii - 1})];
        end
        a{Layer + 2} = sigmoid(Theta{Layer + 1} * a{Layer + 1});

        %计算代价函数
        los_sin = - sum(y .* log(a{Layer + 2}) + (1 - y) .* log(1 - a{Layer + 2}));
        sum_cost = sum_cost + los_sin;

        %反向传播
        delta = cell(1, Layer + 2)
        delta{Layer + 2} = a{Layer + 2} - y;
        for ii = Layer + 1 : -1 : 2
            delta{ii} = Theta{ii}' * delta{ii + 1} .* a{ii} .* (1 - a{ii});
            delta{ii} = delta{ii}(2 : size(delta{ii}));
        end

        %计算Δ
        DeltaPlus = [];
        for ii = 1 : Layer + 1
            DeltaPlusSingle = delta{ii + 1} * a{ii}';
            DeltaPlus = [DeltaPlus; DeltaPlusSingle(:)];
        end
        
        DeltaLine = DeltaLine + DeltaPlus;
        
    end
    
    Delta = cell(1, Layer + 1);
    for ii = 1 : Layer + 1
        Delta{ii} = reshape(DeltaLine(DeltaPos(ii, 1) : DeltaPos(ii, 2)), DeltaSize(ii, :));
    end

    %计算偏导
    D = cell(1, Layer + 1);
    for ii = 1 : Layer + 1
        D{ii} = 1 / batchLength * [Delta{ii}(:, 1), Delta{ii}(:, 2 : size(Delta{ii}, 2)) + lambda * Theta{ii}(:, 2 : size(Theta{ii}, 2))];
    end

    %对Θ进行更新迭代
    for ii = 1 : Layer + 1
        Theta{ii} = Theta{ii} - alpha .* D{ii};
    end
    
    %计算代价函数
    J(step) =  1 / batchLength * sum_cost;
    if(lambda ~= 0) %正则化
        %将偏置单元的权重置为0
        theta0sq = 0;
        for ii = 1 : Layer + 1
            theta0sq = theta0sq + sum(sum(Theta{ii}(:, 2 : size(Theta{ii}, 2)) .^ 2));
        end

        %对代价函数进行正则化
        J(step) =  J(step) + lambda / 2 / minibatch * theta0sq;  %正则化后的代价函数
    end
    disp(['当前代价函数为',num2str(J(step))]);
    
    %判断学习是否停滞
    if mod(step, JReduceCheckStep) == 0 && step >= JReduceCheckStep
        J_avg = mean(J(step - JReduceCheckStep + 1 : step));
        if(J_avg >= 0.96 * J_avg_0)
            alpha = 0.3 * alpha;
            if alpha <= minAlpha
                disp('满足收敛条件，学习停止');
                break;
            end
            disp(['学习开始停滞，减小α至α=', num2str(alpha)]);
            alphaAutoChangeNum = alphaAutoChangeNum + 1;
            alphaAutoChangeStep(alphaAutoChangeNum) = step;
        end
        J_avg_0 = J_avg;
    end

    %实时显示代价函数与识别准确率
    plot(hAxes1, 1 : step, gather(J(1 : step)), '.-b', alphaAutoChangeStep(1 : alphaAutoChangeNum), zeros(alphaAutoChangeNum, 1), 'or');
    xlabel(hAxes1, 'step'); ylabel(hAxes1, 'J(θ)'); title(hAxes1, '代价函数趋势图');
    xlim(hAxes1, [1, step + 1]);
    if rateCheckOpt
        plot(hAxes2, rateStep(1 : rateNum), Rate(1 : rateNum), '.-b', rateStep(1 : rateNum), Rate_v(1 : rateNum), '.-r');
        xlabel(hAxes2, 'step'); ylabel(hAxes2, '准确率'); title(hAxes2, '识别准确率趋势图');
        axis(hAxes2, [1, step + 1, 0, 1]);
    end
    drawnow;
    
    %实时保存数据
    if mod(step, saveStep) == 0
        savepath = ['Theta_step', num2str(step),'.mat'];
        save(savepath,'Theta');
    end
    
end

%保存权重数据
save('Theta.mat','Theta');
disp(['已完成', num2str(step), '次训练，权重已保存至"Theta.mat"']);

if coreNumNow <= 1 && coreNum
    matlabpool close;
elseif coreNumNow ~= coreNum
    matlabpool('open', 'local', coreNumNow);
end