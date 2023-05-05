% 具体操作    global lamda p;
%            lamda=...;
% % %            p=...;
 function [tps]=signal

close all;
clear;
clc;
standard_deviation=1;
fs=2000;                  %采样频率
N=200;
n=1:N;
T=1/fs;
SNR=10;                                 %信噪比dB
SNR1=10.^(SNR/10);                                %所需信噪比转换成非dB
t=n/fs;
  frequency_hop1=[70, 155, 30, 60, 84];
%    frequency_hop1=[70, 135, 30, 60, 84, 40, 199, 128 27 94];
    for i=1:N
        m1=floor((i)/((N+1)/length(frequency_hop1)))+1;
        fh(i)=frequency_hop1(m1);%每个时间点上对应的跳变频率
    end
    frequency_hop_signal=SNR*standard_deviation*cos(2*pi*fh.*n/fs);
   tps=frequency_hop_signal;
%     % %噪声
%     zs1=randn(1,N);                                         %产生高斯白噪声
%     zs1=zs1/std(zs1);                                       %噪声方差归一化
%     zs1=zs1-mean(zs1);                                      %噪声均值设为0
%     b1=sqrt(1);                                             %噪声幅度修正权值
%     zs=b1*zs1;  
%     % signal_power_tps=1/N*sum(frequency_hop_signal.*frequency_hop_signal);          %原始跳频信号功率
%     % SNR_P_biaozhun_tps=signal_power_tps/(b1^2);   %原始跳频信号的信噪比
%     % frequency_hop_signal=sqrt(SNR1/SNR_P_biaozhun_tps)*frequency_hop_signal;   %跳频信号幅度修正
%  s5=frequency_hop_signal;
%     s5=frequency_hop_signal;
%       sig=s5';     
% % % %时域波形
% figure(1)
% plot(t,s5,'LineWidth',2);
% xlabel('时间 t');
% ylabel('幅值 A');

%  不同的lamda，p值进行对比(其中lamda=1,p=1时为S变换)
%   S变换
% global lamda p;
% lamda=1.9;
% p=0.6;
% [tfr,t,f]=st(sig);
% %时频表示
% figure;
%  mesh(t,f,abs(tfr).^2)
% %  subplot(311);
% contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% axis([0 1 0 300]);
% xlabel('时间 t');
% ylabel('频率 f');
% title("l=1,p=1")
% % global lamda p;
% % lamda=0.75;
% % p=1;
% % [tfr,t,f]=st(sig);
% % %时频表示
% % subplot(312);
% % contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 300]);
% % xlabel('时间 t');
% % ylabel('频率 f');
% % title("l=0.75,p=1")
% % 
% % global lamda p;
% % lamda=1;
% % p=1.9;
% % [tfr,t,f]=st(sig);
% % %时频表示
% % subplot(313);
% % contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none');
% % axis([0 1 0 300]);
% % xlabel('时间 t');
% % ylabel('频率 f');
% % title("l=1,p=1.9")