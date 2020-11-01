%%%%%%%%%%%%
%Statistics%
%%%%%%%%%%%%

clear all

% 10 K Attrattivo 

load EnergiaVsPassi_10K_Repulsivo.txt
temp = EnergiaVsPassi_10K_Repulsivo(416:500,2);
x(10)=10;
media(10)= mean(temp);
dev(10) = std(temp);


% 520 K Attrattivo

load EnergiaVsPassi_520K_Repulsivo.txt
temp = EnergiaVsPassi_520K_Repulsivo(416:500,2);
x(520)=520;
media(520)= mean(temp);
dev(520) = std(temp);

% 1500 K Attrattivo

load EnergiaVsPassi_1500K_Repulsivo.txt
temp = EnergiaVsPassi_1500K_Repulsivo(416:500,2);
x(1500)=1500;
media(1500)= mean(temp);
dev(1500) = std(temp);

% 2500 K Attrattivo

load EnergiaVsPassi_2500K_Repulsivo.txt
temp = EnergiaVsPassi_2500K_Repulsivo(416:500,2);
x(2500)=2500;
media(2500)= mean(temp);
dev(2500) = std(temp);