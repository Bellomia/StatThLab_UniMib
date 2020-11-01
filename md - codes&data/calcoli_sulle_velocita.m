clear all
clear fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global x0;
global y0;
global z0;
global vx0;
global vy0;
global vz0;
global nat;
global mass;
global T0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x0, y0, z0] = load_crystal;

seed = 16324478;
rng(seed);              % Inizializzazione generatore random [rand]
T0 = 1500;               % Temperatura Iniziale in Kelvin
mass = 108*1.66e-27/16;  % Massa in eV/c^2, c in Å/s

[vx0, vy0, vz0] = speed_extraction;

% Calcoliamo <v_i^2> e <v_i>

vmx=0;
vmy=0;
vmz=0;
vv=0;

for i=1:nat
    
    vmx = vmx + vx0(i)/nat;
    vmy = vmy + vy0(i)/nat;
    vmz = vmz + vz0(i)/nat;
    vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
end

vm = sqrt(vmx^2+vmy^2+vmz^2) % -> DISPLAY
vrms = sqrt(vv);

% <v> non viene nullo, poiché non siamo rigorosamente al limite
% termodinamico! Stiamo mediando sull'ensemble anziché temporalmente, senza
% che sia del tutto lecito farlo. Ciò produce, per conservazione della qdm
% totale (le forze LJ sono interne), una traslazione del centro di massa
% del cluster. Sarà allora opportuno sottrarre il moto del centro di massa.

KT = T0/11603;
Ekin = 0.5*mass*vrms^2;
T_eff = 2/3*(Ekin/KT)*T0 % -> DISPLAY

% Dal teorema di equipartizione possiamo osservare inoltre che l'aver
% estratto un numero finito di velocità, per di più con una distribuzione
% solo "approssimativamente maxwelliana", ci comporta una perturbazione
% artificiale della temperatura...

vCMx = vmx;
vCMy = vmy;
vCMz = vmz;

vmx = 0;
vmy = 0;
vmz = 0;
vv = 0;

for i=1:nat
   
    vx0(i) = vx0(i) - vCMx;
    vy0(i) = vy0(i) - vCMy;
    vz0(i) = vz0(i) - vCMz;
    vmx = vmx + vx0(i)/nat;
    vmy = vmy + vy0(i)/nat;
    vmz = vmz + vz0(i)/nat;
    vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
end

vm = sqrt(vmx^2+vmy^2+vmz^2) % -> DISPLAY

Ekin = 0.5*mass*vv;

T_eff = 2/3*(Ekin/KT)*T0 % -> DISPLAY

% Adesso la velocità media è nulla, come vogliamo. Tuttavia resta ancora da
% risolvere il problema della temperatura...
% La soluzione a ciò è molto semplice, è sufficiente ricorreggere con
% l'opportuno fattore moltiplicativo i vettori vx0, vy0 e vz0.

vm = 0;
vv = 0;

for i=1:nat
    
    vx0(i) = vx0(i)*sqrt(T0/T_eff);
    vy0(i) = vy0(i)*sqrt(T0/T_eff);
    vz0(i) = vz0(i)*sqrt(T0/T_eff);
    vmx = vmx + vx0(i)/nat;
    vmy = vmy + vy0(i)/nat;
    vmz = vmz + vz0(i)/nat;
    vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
end

vm = sqrt(vmx^2+vmy^2+vmz^2) % -> DISPLAY

Ekin = 0.5*mass*vv;

T_giusta = 2/3*(Ekin/KT)*T0 % -> DISPLAY

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Allora la ricorrezione può essere resa definitiva sulle vx0, vy0, vz0:
%
%   vCMx=0;
%   vCMy=0;
%   vCMz=0;
%
%   for i=1:nat
%   
%       vCMx = vCMx + vx0(i)/nat;
%       vCMy = vCMy + vy0(i)/nat;
%       vCMz = vCMz + vz0(i)/nat;
%    
%   end
%
%   vv = 0;
%    
%   for i=1:nat
%   
%       vx0(i) = vx0(i) - vCMx;
%       vy0(i) = vy0(i) - vCMy;
%       vz0(i) = vz0(i) - vCMz;
%       vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
%    
%   end
%    
%   KT = T0/11603;
%   Ekin = 0.5*mass*vv;         % Teorema di Equipartizione
%   T_eff = 2/3*(Ekin/KT)*T0;
%
%
%   for i=1:nat
%   
%       vx0(i) = vx0(i)*sqrt(T0/T_eff);
%       vy0(i) = vy0(i)*sqrt(T0/T_eff);
%       vz0(i) = vz0(i)*sqrt(T0/T_eff);
%   
%   end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%