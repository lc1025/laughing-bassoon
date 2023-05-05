%% 测试

%% ②生成噪声样本
numSamples = 400;
numNoiseSamples = 16 * numSamples;

for p1 = 1:numNoiseSamples
    x = wgn(1,200,5); %生成噪声信号
       %
    global lamda p;
    lamda=1.9;
    p=0.6;
    [tfr,t,f]=st(x);
    %
    noise = tfr./sqrt(mean(abs(tfr).^2));%将噪声功率归一化

    datasets_noise(:,:,:,p1) = cat(3,real(noise),imag(noise)); % 在三维拼接IQ路，第四维拼接一个个信号样本咯

    noise_label(:,p1) = 0; % 设置标签喽，0表示噪声
      
end

%% ☆☆☆判决门限的确定
%这里scores第一列为DSSS置信度，第二列为noise置信度
[YTrainPred,scores] = classify(trainedNet,datasets_noise);

%% 取出noise置信度由小到大排列
scores1 = scores(:,1);
scores2 = sort(scores1);

 %按照虚警概率设置判决门限
PDD_DL_001 = [];%Pfa=0.01,不同信噪比下的检测概率

numNoiseSamples = 16 * numSamples;

Pfa = 0.01;
    
Pth = scores2(ceil(numNoiseSamples * Pfa));%判决门限

z = 1;%每次信噪检测概率结束后+1

for DB = -30:2:0      
    for p1 = 1:numSamples
        % 整合信号
        [tps]=signal;
        x=tps;
        x = awgn(x, DB, 'measured'); % 加入高斯白噪声
    
        %
        global lamda p;
        lamda=1.9;
        p=0.6;
        [tfr,t,f]=st(x);
        %
    
    
        signal_FH = tfr./sqrt(mean(abs(tfr).^2)); %将信号功率归一化，生成单个信号样本
    
        datasets_FH(:,:,:,p1) = cat(3,real(signal_FH),imag(signal_FH)); % 在第四维凭借一个个信号样本咯
    
        signal_label(:,p1) = 1; % 设置标签喽，1表示加噪信号
    end

    %进行准确率判决
    num = 0;
    [YTrainPred,scores] = classify(trainedNet,datasets_FH);
    %取出信号置信度由小到大排列
    scores1 = scores(:,1);
    for i = 1:numSamples
        if scores1(i) < Pth
            num = num+1;
        end
    end
    testAccuracy = num/numSamples;
    if Pfa == 0.01
        PDD_DL_001(z) = testAccuracy;%将不同信噪比下的检测概率放到一个数组中
    end
    z = z+1;  
end

% save PDD_differentFa PDD_DL_001 PDD_DL_002 PDD_DL_003 Pfa_initial;

%% 画图
figure
SNR = -30:2:0;
plot(SNR,PDD_DL_001,'-or'); %线性，标记，颜色
%虚警概率为0.01时，DL为0点；自相关为*点
axis([-30,0,0,1])  %确定x轴与y轴框图大小
set(gca,'XTick',[-30:5:0]) %x轴范围-20-0，间隔5。利用set(gca,'propertyname','propertyvalue'......)命令可以调整图形的坐标属性。
set(gca,'YTick',[0:0.2:1]) %y轴范围0-1，间隔0.2
legend('Proposed CNN,Pfa=0.01','Location','SouthEast');   %右下角标注
xlabel('SNR（dB）')  %x轴坐标描述
ylabel('Probability of detection') %y轴坐标描述
grid on

% Pfa_initial = 1 - P00 %输出原虚警概率