function [Num, Cfd] = HandwritingRecognition(InputImageT, Theta)
load('Theta.mat');
imsize = 28;
ipsize = size(InputImageT);

InputImage = InputImageT';
Image = zeros(imsize);
xs = 1;
for ii = 1 : imsize
    xe = xs + round((ipsize(2) - xs + 1) / (imsize - ii + 1)) - 1;
    ys = 1;
    for jj = 1 : imsize
        ye = ys + round((ipsize(1) - ys + 1) / (imsize - jj + 1)) - 1;
        piece = InputImage(xs : xe, ys : ye);
        Image(ii, jj) = ceil(sum(sum((piece .^ 3) / (xe - xs + 1) / (ye - ys + 1))) ^ (1 / 3));
        ys = ye + 1;
    end
    xs = xe + 1;
end

x = Image(:);
y = predict(Theta, x);

[Cfd, num] = max(y);
Num = num - 1;