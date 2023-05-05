%%
t = -0.5:0.02:0.5;
f = 0:1:50;
lamda=1;
p=1;
count = 1;
for i = 1:length(t)
    for j = 1:length(f)
        w(i,j)=((lamda*abs(f(j))^p)/sqrt(2*pi))*(exp(-(t(i)^2*lamda^2*(f(j))^(2*p))/2));
    end
end
%%
%%
t1 = -0.5:0.02:0.5;
f1 = 0:1:50;
lamda=1;
p=0.5;
count = 1;
for i = 1:length(t1)
    for j = 1:length(f1)
        w1(i,j)=((lamda*abs(f1(j))^p)/sqrt(2*pi))*(exp(-(t1(i)^2*lamda^2*(f1(j))^(2*p))/2));
    end
end
%%
%%
t2= -0.5:0.02:0.5;
f2 = 0:1:50;
lamda=0.5;
p=1;
count = 1;
for i = 1:length(t2)
    for j = 1:length(f2)
        w2(i,j)=((lamda*abs(f2(j))^p)/sqrt(2*pi))*(exp(-(t(i)^2*lamda^2*(f2(j))^(2*p))/2));
    end
end
%%
figure()
subplot(1,3,1)
surf(f, t, w);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
shading interp
%  axis([0 1 0 1000]);
xlabel('频率 f');
 ylabel('时间 t');
 zlabel('幅度');
title("λ=1,p=1")
subplot(1,3,2)
surf(f1, t1, w1);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
shading interp
xlabel('频率 f');
 ylabel('时间 t');
 zlabel('幅度');
title("λ=1,p=0.5")
subplot(1,3,3)
surf(f2, t2, w2);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
shading interp
xlabel('频率 f');
 ylabel('时间 t');
 zlabel('幅度');
title("λ=0.5,p=1")