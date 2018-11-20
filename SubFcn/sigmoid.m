function [g] = sigmoid(z)
%Sigmoid function (Logistic function)

g = 1 ./ (1 + exp(-z));