
function [dps,tfs,sps]=tds2_3
fs=2000;
fdp1=200;                               %��Ƶ�ź�Ƶ�ʵ�λΪHz

n=0:199;                              %�źŹ۲�ʱ��
b=length(n);                            %�źų���
for i=1:b                               %������Ƶ����Ϊ0.5ms��1ms��0.25ms����Ƶ�ź�
                 
    if i>=10&&i<=17                 %ͻ���ź�
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
     %ɨƵ�ź�
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

dps1=sqrt(7)*cos(2*pi*fdp1*n/fs);     %��һ����Ƶ�źţ�����Ƶ��Ϊ2.56MHz

tfs=sqrt(10)*atf.*cos(2*pi*ftf.*n/fs);  %ͻ���ź�
dps=dps1;  
