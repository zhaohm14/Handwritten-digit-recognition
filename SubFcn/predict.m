function h = predict(Theta , x)

Layer = length(Theta) - 1;

%ªÒ»°‘§≤‚÷µ
a = cell(Layer + 1, 1);
a{1} = [1; x];
for ii = 2 : Layer + 1
    a{ii} = [1; sigmoid(Theta{ii - 1} * a{ii - 1})];
end
h = sigmoid(Theta{Layer + 1} * a{Layer + 1});