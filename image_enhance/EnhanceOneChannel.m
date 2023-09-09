function ImOut = EnhanceOneChannel(ImChannel)
% 计算计算单个通道的反射分量
% 1.对全图进行照射分量估计
% 2.减去照射分量
% 3.灰度拉伸
ImChannel = ImChannel./max(ImChannel(:));
ImRetinex = round(exp(ImChannel.*5.54));
ImOut = uint8(ImRetinex);
end

