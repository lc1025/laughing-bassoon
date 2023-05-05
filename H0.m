%加干扰
function [zs] = H0
clear all
n=0:199;
N=length(n);
fs=2000;
t=n./fs;
SDR=0;
SDR1=10.^(SDR/10); %dBz转功率比值
fangcha=2;                     %噪声方差

zs=randn(1,N);
zs=zs/std(zs);              %噪声功率=噪声方差
zs=zs-mean(zs);
b=sqrt(fangcha);            %sqrt中的值就是方差
zs=b*zs;
[dps,tfs,sps]=tds2_3;
grs=tfs+sps;
dps=dps;
gl_grs=1/N*sum(grs.*grs);
gl_dps=1/N*sum(dps.*dps);
gl_zs=1/N*sum(zs.*zs);
xg_bz=gl_grs/gl_zs; %信干功率比值
tfs2=tfs*sqrt(SDR1/xg_bz);
sps2=sps*sqrt(SDR1/xg_bz);  
grs2=tfs2+sps2+dps;
gl_sps2=1/N*sum(sps2.*sps2);
gl_tfs2=1/N*sum(tfs2.*tfs2);
gl_grs2=1/N*sum(grs2.*grs2);
xz_bz=gl_grs2/gl_zs;
zs=grs2;
s5=zs;
sig=s5'; 
%  % %时域波形
% figure(1) 
% plot(t,s5,'LineWidth',2); 
% xlabel('时间 t'); ylabel('幅值 A');

%  不同的lamda，p值进行对比(其中lamda=1,p=1时为S变换) %   S变换 
 global lamda p; 
 lamda=1;
 p=0; 
[tfr,t,f]=st(sig); %时频表示 figure;
mesh(t,f,abs(tfr).^2) 
% subplot(311);
contourf(t/fs,f*fs,abs(tfr).^2,'LinesTyle','none'); 
% axis([0 0.1 0 1000]);
xlabel('时间 t'); ylabel('频率 f'); 
title("l=1.9,p=0.6")
% %%进行时频对消
% P1=abs(tfr).^2;
% % P1=tfs;
% P1_average=zeros(length(f),1);         
% for i=1:length(f)
%     for j=1:length(t)
%        P1_average(i)=P1_average(i)+P1(i,j);            %对应频率功率求和
%     end
% end
% P1_average=P1_average/length(t);                      %求平均功率
% %时频对消
% for i=1:length(f)
%     for j=1:length(t)
%          Psub(i,j)=P1(i,j)-P1_average(i);
%     end
% end
% contourf(t/fs,f*fs,abs(Psub).^2,'LinesTyle','none'); 
% % axis([0 1 0 300]);
% xlabel('时间 t'); ylabel('频率 f'); 
% title("l=1.9,p=0.6")

           