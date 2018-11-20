function [rate, Y_p, H_p] = acyRate(X, Y, Theta, m)
%此程序用于计算某一权重对某一测试集的识别准确率

H = zeros(size(Y, 1), m);
global PrmStg;
if isfield(PrmStg, 'GPUOpt')
    if PrmStg.GPUOpt
        H = gpuArray(single(H));
    end
end

%获取预测值
for ii = 1 : m
    H(:, ii) = predict(Theta, X(:, ii));
end

[~, Y_p] = max(Y);                      %测试集的真值位置
[~, H_p] = max(H);                      %预测值的真值位置
True = find(Y_p == H_p);                %预测正确的值的位置
rate = size(True, 2) / m;               %预测正确的比例