function w = wavelet( x, a, b )
%WAVELET 函数
%墨西哥帽子小波函数
%a不能为0
z = (x - b) / a;
z = z^2; % 此行和下一行使用z来表示z^2
w = (1 - z) * exp(-z/2) / sqrt( abs(a) ); % 使用z来表示z^2