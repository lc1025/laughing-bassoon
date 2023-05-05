%% 参数设置
numSamples_perSNR = 400; % 每个dB下生成的样本数量
numSamples = 16 * numSamples_perSNR - 1;  % 总样本数量

%% 生成不同信噪比下的加噪的跳频信号样本

for p1 = 1:numSamples
     
    snr = -floor(p1/numSamples_perSNR)*2; %每个SNR下生成1000个信号，-30到0dB，间隔而2dB

    % 整合信号
    [tps]=signal;
    x=tps;
    x = awgn(x, snr, 'measured'); % 加入高斯白噪声

    %
    global lamda p;
    lamda=1.9;
    p=0.6;
    [tfr,t,f]=st(x);
    %


    signal_FH = tfr./sqrt(mean(abs(tfr).^2)); %将信号功率归一化，生成单个信号样本
%     %%去除频率的影响
%     signal_FH=signal_FH./(lamda*abs(f').^p);

    datasets_FH(:,:,:,p1) = cat(3,real(signal_FH),imag(signal_FH)); % 在第四维凭借一个个信号样本咯

    signal_label(:,p1) = 1; % 设置标签喽，1表示加噪信号
    
end


%% 生成不同信噪比下的噪声样本

for p1 = 1:numSamples
     
    x = wgn(1,200,5); %生成噪声信号

    %
    global lamda p;
    lamda=1.9;
    p=0.6;
    [tfr,t,f]=st(x);
    %

    noise = tfr./sqrt(mean(abs(tfr).^2));%将噪声功率归一化
%     %%去除频率的影响
%    noise=noise./(lamda*abs(f').^p);

    datasets_noise(:,:,:,p1) = cat(3,real(noise),imag(noise)); % 在三维拼接IQ路，第四维拼接一个个信号样本咯

    noise_label(:,p1) = 0; % 设置标签喽，0表示噪声
    
end

%% 训练数据集生成
XTrain = cat(4,datasets_FH,datasets_noise);
YTrain = cat(2,signal_label,noise_label);
YTrain = categorical(YTrain);%标签必须变成categorical类型，才能在网络中训练

%% 验证集下数据集生成+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% 参数设置
numSamples_perSNR_val = 100; % 每个dB下生成的样本数量
numSamples_val = 16 * numSamples_perSNR_val - 1;  % 总样本数量

%% 生成不同信噪比下的加噪的跳频信号样本

for p1 = 1:numSamples_val
     
    snr = -floor(p1/numSamples_perSNR_val)*2; %每个SNR下生成1000个信号，-30到0dB，间隔而2dB

    % 整合信号
    [tps]=signal;
    x=tps;
    x = awgn(x, snr, 'measured'); % 加入高斯白噪声

    %
    global lamda p;
    lamda=1.9;
    p=0.6;
    [tfr,t,f]=st(x);
    %


    signal_FH = tfr./sqrt(mean(abs(tfr).^2)); %将信号功率归一化，生成单个信号样本
%     %%去除频率的影响
%     signal_FH=signal_FH./(lamda*abs(f').^p);

    datasets_FH_val(:,:,:,p1) = cat(3,real(signal_FH),imag(signal_FH)); % 在第四维凭借一个个信号样本咯

    signal_label_val(:,p1) = 1; % 设置标签喽，1表示加噪信号
    
end


%% 生成不同信噪比下的噪声样本

for p1 = 1:numSamples_val
     
    x = wgn(1,200,5); %生成噪声信号

    %
    global lamda p;
    lamda=1.9;
    p=0.6;
    [tfr,t,f]=st(x);
    %

    noise = tfr./sqrt(mean(abs(tfr).^2));%将噪声功率归一化
%      %%去除频率的影响
%    noise=noise./(lamda*abs(f').^p);

    datasets_noise_val(:,:,:,p1) = cat(3,real(noise),imag(noise)); % 在三维拼接IQ路，第四维拼接一个个信号样本咯

    noise_label_val(:,p1) = 0; % 设置标签喽，0表示噪声
    
end


%% 验证数据集生成
XValidation = cat(4,datasets_FH_val,datasets_noise_val);
YValidation = cat(2,signal_label_val,noise_label_val);
YValidation = categorical(YValidation);

%% 训练选项
maxEpochs = 20;
miniBatchSize = 128;% 小批量128 ？？？跑不动，将miniBatchSize变小
trainingSize = numel(YTrain);%样本数22000
validationFrequency = floor(trainingSize/miniBatchSize);%验证频率每一轮结束后


 options = trainingOptions('adam', ...
  'InitialLearnRate',0.01, ... % 初始学习率0.01，之后每3轮减少1/10，考虑减小学习率
  'MaxEpochs',maxEpochs, ...
  'MiniBatchSize',miniBatchSize, ...
  'Shuffle','every-epoch', ...
  'ValidationData',{XValidation,YValidation}, ...
  'ValidationFrequency',validationFrequency,...
  'LearnRateSchedule', 'piecewise', ...
  'LearnRateDropPeriod', 3, ...
  'LearnRateDropFactor', 0.1,...
  'Plots','training-progress',...
  'Verbose',1);%命令行打印准确率等信息

[trainedNet,info] = trainNetwork(XTrain,YTrain,layers_1 ,options);