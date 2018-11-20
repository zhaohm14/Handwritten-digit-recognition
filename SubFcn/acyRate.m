function [rate, Y_p, H_p] = acyRate(X, Y, Theta, m)
%�˳������ڼ���ĳһȨ�ض�ĳһ���Լ���ʶ��׼ȷ��

H = zeros(size(Y, 1), m);
global PrmStg;
if isfield(PrmStg, 'GPUOpt')
    if PrmStg.GPUOpt
        H = gpuArray(single(H));
    end
end

%��ȡԤ��ֵ
for ii = 1 : m
    H(:, ii) = predict(Theta, X(:, ii));
end

[~, Y_p] = max(Y);                      %���Լ�����ֵλ��
[~, H_p] = max(H);                      %Ԥ��ֵ����ֵλ��
True = find(Y_p == H_p);                %Ԥ����ȷ��ֵ��λ��
rate = size(True, 2) / m;               %Ԥ����ȷ�ı���