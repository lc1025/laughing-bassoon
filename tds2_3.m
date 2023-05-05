
function [dps,tfs,sps]=tds2_3
fs=2000;
fdp1=200;                               %定频信号频率单位为Hz

n=0:199;                              %信号观测时间
b=length(n);                            %信号长度
for i=1:b                               %构造跳频周期为0.5ms、1ms、0.25ms的跳频信号
                 
    if i>=10&&i<=17                 %突发信号
         ftf(i)=300;
         atf(i)=1; 
%     elseif i>=90&&i<=100
%          ftf(i)=590;
%          atf(i)=1; 
%     elseif i>=130&&i<=140
%         ftf(i)=370;
%         atf(i)=1; 
     else
        ftf(i)=0;  
        atf(i)=0;
    end
     %扫频信号
     if i>=40&&i<=50                
        t=i-40;
        fsp(i)=0.1*t+100;
        sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
%     elseif i>=50&&i<=70         
%         t=i-50;
%         fsp(i)=0.1*t+100;
%         sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
%     elseif i>=90&&i<=110
%         t=i-90;
%         fsp(i)=0.1*t+100;
%         sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
%      elseif i>=130&&i<=150 
%         t=i-130;
%         fsp(i)=0.1*t+100;
%         sps(i)=sqrt(10)*cos(2*pi*fsp(i)*t/fs);
     else
        sps(i)=0;
    end
end

dps1=sqrt(7)*cos(2*pi*fdp1*n/fs);     %第一个定频信号，采样频率为2.56MHz

tfs=sqrt(10)*atf.*cos(2*pi*ftf.*n/fs);  %突发信号
dps=dps1;  
