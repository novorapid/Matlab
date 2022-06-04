%filtrul butterworth
clear all;close all
%ordinul filtrului
n=4;
%pulsatia de taiere
wt=20;
% se calculeaza constelatia polilor
for k=1:n,
 s(k)=exp(i*(2*k-1+n)/(2*n)*pi);
end;
% se elimina polii complecsi falsi
s=1e6*s;s=round(s);s=s/1e6;
% se defineste filtrul cu wt=1
sys=zpk([],s,1);
sys=tf(sys)
[m,p,w]=bode(sys);
mdb=20*log10(m(1,:));
figure(1);
semilogx(w,mdb);hold on;
% se ajusteaza coeficientii filtrului pt wt din aplicatie
[num,den]=tfdata(sys,'v');
for i=1:n,
 a1=1/wt^(n-i+1)
 den1(i)=den(i)*a1;
end;
den1(n+1)=den(n+1);
% filtrul cu wt din aplicatie
sys1=tf(num,den1)
[m,p,w]=bode(sys1);
mdb=20*log10(m(1,:));
semilogx(w,mdb);grid;hold off;axis([1e-1 1e3 -80 10]);
% deducerea functiilor indiciale
figure(2);t=[0:0.01:30];
step(sys,t);grid; hold on;
step(sys1,t);
% discretizarea functiei de transfer si trasarea %caracteristicii Bode
sysd=c2d(sys1,0.01,'foh');
figure(3);
[md,pd,wd]=bode(sysd);
mddb=20*log10(md(1,:));
semilogx(wd,mddb);grid;axis([1e-1 1e3 -80 10]);
figure(4);bode(sysd);grid
%*****************************
% filtrarea unui semnal test
figure(6);
load semnal;
t1=0:0.01:10;
yf=lsim(sys1,y(2,:),t1);
plot(t1,yf,t1,y(2,:),'r');grid;