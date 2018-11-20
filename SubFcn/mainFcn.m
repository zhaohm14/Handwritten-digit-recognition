function mainFcn

%--------------------ѵ������---------------------
global PrmStg;

totalStep = PrmStg.totalStep;                       %���ѧϰ����
m = PrmStg.m;                                     	%ѵ��������
m_v = PrmStg.m_v;                                   %��֤������
alpha = PrmStg.alphaDis;                            %ѧϰ��
lambda = PrmStg.lambda;                             %���򻯳ͷ�
minibatch = PrmStg.minibatch;                       %ÿ�ε���Ӧ��MINI Batch����������
minAlpha = PrmStg.minAlpha;                         %���������ж�����
JReduceCheckStep = PrmStg.JReduceCheckStep;         %���ۺ��������ж��ĵ����������
accuracyAim = PrmStg.accuracyAim;               	%������֤����׼ȷ�ʵ�Ԥ��Ŀ��
rateCheckStep = PrmStg.rateCheckStep;               %���ʶ��׼ȷ�ȵĵ����������
saveStep = PrmStg.saveStep;                         %�ڵ����б������ݵĵ����������
GPUOpt = PrmStg.GPUOpt;                             %����GPU���ٵ�ѡ��
coreNum = PrmStg.coreNum;                       	%ʹ�õ�CPU��������
restartMode = PrmStg.restartMode;                   %ֵΪ'Resume'ʱ����ȡ����Theta�������㣬ֵΪ'Restart'ʱ�����������ʼ��
rateCheckOpt = PrmStg.rateCheckOpt;                 %���ʶ��׼ȷ�ʵ�ѡ��
%------------------------------------------------


%----------------------�ܹ�----------------------
global unit_net;
global sample_size_x sample_size_y
unit = [sample_size_x; unit_net; sample_size_y];    %����������ĵ�Ԫ�������������������������ƫ�õ�Ԫ��
Layer = size(unit, 1) - 2;                          %��ȡ���������
%------------------------------------------------


%----------------------����----------------------
%ѵ����
global train_x train_y;
X = train_x(1 : m, :)';                             %��������
Y = train_y(1 : m, :)';                             %Ԥ������
%��֤��
X_v = train_x(m + 1 : m + m_v, :)';
Y_v = train_y(m + 1 : m + m_v, :)';
%------------------------------------------------


%-------------------Ȩ�س�ʼ��--------------------
switch restartMode
    %---------------------ʹ������Ȩ�ؽ��г�ʼ��---------------------
    case 'Resume'
        Theta = myload('Theta.mat');

    %---------------------ʹ������������г�ʼ��---------------------
    case 'Restart'
        epsilon = PrmStg.epsilon;
        Theta = cell(1, Layer + 1);
        for ii = 1 : Layer + 1
            Theta{ii} = epsilon * (1 - 2 * rand(unit(ii + 1), unit(ii) + 1));
        end

end
%------------------------------------------------


%-------------------������ʼ��--------------------
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


%--------------------�������---------------------
% GPU����
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

% ���߳�
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
        disp(['��һ����ʱ��', num2str(t), 's']);
    end
    tic;
    
    %����ʶ��׼ȷ��
    if rateCheckOpt
        if mod(step, rateCheckStep) == 1 || rateCheckStep == 1
            m_rp = randperm(m);
            m_v_rp = randperm(m_v);
            X_r = X(:, m_rp(1 : minibatch));
            Y_r = Y(:, m_rp(1 : minibatch));
            X_v_r = X_v(:, m_v_rp(1 : minibatch));
            Y_v_r = Y_v(:, m_v_rp(1 : minibatch));
            rate = acyRate(X_r, Y_r, Theta, minibatch);
            disp(['ѵ����ʶ��׼ȷ��Ϊ:',num2str(rate * 100),'%']);
            rate_v = acyRate(X_v_r, Y_v_r, Theta, minibatch);
            disp(['��֤��ʶ��׼ȷ��Ϊ:',num2str(rate_v * 100),'%']);
            rateNum = rateNum + 1;
            rateStep(rateNum) = step;
            Rate(rateNum) = rate;
            Rate_v(rateNum) = rate_v;
            if rate_v > accuracyAim
                disp('��֤��ʶ��׼ȷ���ѴﵽԤ��Ŀ��');
                break;
            end
        end
    end
    
    %��ʼ����
    sum_cost = 0;
    %�Ԧ����г�ʼ��
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
    
    %���㵱ǰMINI Batchλ��
    batchEnd = batchStart + minibatch;
    mb = batchStart : min(batchEnd, m);
    batchLength = length(mb);
    batchStart = mod(batchEnd, m);
    
    parfor samSrlNum = mb
        x = X(:, samSrlNum);
        y = Y(:, samSrlNum);
        
        %ǰ�򴫲�
        a = cell(1, Layer + 2);
        a{1} = [1; x];
        for ii = 2 : Layer + 1
            a{ii} = [1; sigmoid(Theta{ii - 1} * a{ii - 1})];
        end
        a{Layer + 2} = sigmoid(Theta{Layer + 1} * a{Layer + 1});

        %������ۺ���
        los_sin = - sum(y .* log(a{Layer + 2}) + (1 - y) .* log(1 - a{Layer + 2}));
        sum_cost = sum_cost + los_sin;

        %���򴫲�
        delta = cell(1, Layer + 2)
        delta{Layer + 2} = a{Layer + 2} - y;
        for ii = Layer + 1 : -1 : 2
            delta{ii} = Theta{ii}' * delta{ii + 1} .* a{ii} .* (1 - a{ii});
            delta{ii} = delta{ii}(2 : size(delta{ii}));
        end

        %���㦤
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

    %����ƫ��
    D = cell(1, Layer + 1);
    for ii = 1 : Layer + 1
        D{ii} = 1 / batchLength * [Delta{ii}(:, 1), Delta{ii}(:, 2 : size(Delta{ii}, 2)) + lambda * Theta{ii}(:, 2 : size(Theta{ii}, 2))];
    end

    %�Ԧ����и��µ���
    for ii = 1 : Layer + 1
        Theta{ii} = Theta{ii} - alpha .* D{ii};
    end
    
    %������ۺ���
    J(step) =  1 / batchLength * sum_cost;
    if(lambda ~= 0) %����
        %��ƫ�õ�Ԫ��Ȩ����Ϊ0
        theta0sq = 0;
        for ii = 1 : Layer + 1
            theta0sq = theta0sq + sum(sum(Theta{ii}(:, 2 : size(Theta{ii}, 2)) .^ 2));
        end

        %�Դ��ۺ�����������
        J(step) =  J(step) + lambda / 2 / minibatch * theta0sq;  %���򻯺�Ĵ��ۺ���
    end
    disp(['��ǰ���ۺ���Ϊ',num2str(J(step))]);
    
    %�ж�ѧϰ�Ƿ�ͣ��
    if mod(step, JReduceCheckStep) == 0 && step >= JReduceCheckStep
        J_avg = mean(J(step - JReduceCheckStep + 1 : step));
        if(J_avg >= 0.96 * J_avg_0)
            alpha = 0.3 * alpha;
            if alpha <= minAlpha
                disp('��������������ѧϰֹͣ');
                break;
            end
            disp(['ѧϰ��ʼͣ�ͣ���С������=', num2str(alpha)]);
            alphaAutoChangeNum = alphaAutoChangeNum + 1;
            alphaAutoChangeStep(alphaAutoChangeNum) = step;
        end
        J_avg_0 = J_avg;
    end

    %ʵʱ��ʾ���ۺ�����ʶ��׼ȷ��
    plot(hAxes1, 1 : step, gather(J(1 : step)), '.-b', alphaAutoChangeStep(1 : alphaAutoChangeNum), zeros(alphaAutoChangeNum, 1), 'or');
    xlabel(hAxes1, 'step'); ylabel(hAxes1, 'J(��)'); title(hAxes1, '���ۺ�������ͼ');
    xlim(hAxes1, [1, step + 1]);
    if rateCheckOpt
        plot(hAxes2, rateStep(1 : rateNum), Rate(1 : rateNum), '.-b', rateStep(1 : rateNum), Rate_v(1 : rateNum), '.-r');
        xlabel(hAxes2, 'step'); ylabel(hAxes2, '׼ȷ��'); title(hAxes2, 'ʶ��׼ȷ������ͼ');
        axis(hAxes2, [1, step + 1, 0, 1]);
    end
    drawnow;
    
    %ʵʱ��������
    if mod(step, saveStep) == 0
        savepath = ['Theta_step', num2str(step),'.mat'];
        save(savepath,'Theta');
    end
    
end

%����Ȩ������
save('Theta.mat','Theta');
disp(['�����', num2str(step), '��ѵ����Ȩ���ѱ�����"Theta.mat"']);

if coreNumNow <= 1 && coreNum
    matlabpool close;
elseif coreNumNow ~= coreNum
    matlabpool('open', 'local', coreNumNow);
end