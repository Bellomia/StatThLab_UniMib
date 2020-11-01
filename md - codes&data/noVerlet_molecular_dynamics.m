clear all
clear fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global x0;
global y0;
global z0;
global vx0;
global vy0;
global vz0;
global rc;
global rp;
global rv;
global nat;
global nvic;
global ivic;
global U_smoothed;
global Fx;
global Fy;
global Fz;
global Apol;
global Bpol;
global Cpol;
global Dpol;
global epsilon;
global sigma;
global mass;
global  T0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
rv = 4.8;      % Raggio per le gabbie di Verlet

epsilon = 0.345; % Parametri Fisici
sigma = 2.644;   % di Lennard-Jones

mass = 108*1.66e-27/16;  % Massa in eV/c^2, c in �/s

difference = rp - rc;                       
sum = rp + rc;
Epol = 4*epsilon*(sigma^12/(rp)^12 - sigma^6/(rp)^6);
Fpol = 4*epsilon*(-12*sigma^12/(rp)^13 + 6*sigma^6/(rp)^7);
Dpol = Fpol/difference^2 - 2*Epol/difference^3;
Cpol = Fpol/(2*difference) - 3/2*Dpol*sum;
Bpol = -2*Cpol*rc - 3*Dpol*rc^2;
Apol = Cpol*rc^2 + 2*Dpol*rc^3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x0, y0, z0] = load_100crystal;    

[nvic, ivic] = make_nearlist;

[U_smoothed] = smoothed_static_energy;
    
[Fx, Fy, Fz] = forces;

seed = 16324478;
rng(seed);                  % Inizializzazione generatore random [rand]
T0 = 600;                    % Temperatura Iniziale in Kelvin
mass = (108*1.66e-27)/16;   % Massa in eV/c^2, c in �/s

[vx0, vy0, vz0] = speed_extraction; % Condizione Iniziale, fissata T0
[vx0, vy0, vz0] = speed_correction(vx0, vy0, vz0); % Coordinate interne e rinormalizzazione

dt = 7*10^(-15);
stepnumber = 12000/7;
normalizednumber = round((12000-2000)/7);

temperature = fopen('temperature.txt', 'w');
energie = fopen('energie.txt', 'w');

hold on

for step = 1:stepnumber
    
    for i = 1:nat
        
        x0(i) = x0(i) + vx0(i)*dt + 1/2*(Fx(i)/mass)*dt^2;
        y0(i) = y0(i) + vy0(i)*dt + 1/2*(Fy(i)/mass)*dt^2;
        z0(i) = z0(i) + vz0(i)*dt + 1/2*(Fz(i)/mass)*dt^2;
       
    end
    
    oldFx = Fx;
    oldFy = Fy;
    oldFz = Fz;
            
    [nvic, ivic] = make_nearlist;
    [Fx, Fy, Fz] = forces;
    
    for i = 1:nat
        
        vx0(i) = vx0(i) + ((Fx(i)+oldFx(i))/(2*mass))*dt;
        vy0(i) = vy0(i) + ((Fy(i)+oldFy(i))/(2*mass))*dt;
        vz0(i) = vz0(i) + ((Fz(i)+oldFz(i))/(2*mass))*dt;
        
    end
    
    % VERIFICA

    vv = 0;

    for i=1:nat

        vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
    end

    KB = 1/11603;
    Ekin = 0.5*mass*vv;
    Tf = 2/3*(Ekin/KB); 
    
    fprintf(temperature, '%f\n', Tf);
    %scatter(step, Tf);
    
    [U_smoothed] = smoothed_static_energy;
    ENERGY = U_smoothed + Ekin*nat; % Ekin è l'energia media!

    fprintf(energie, '%f\n', ENERGY);
    %scatter(step, ENERGY);
    
    Remaining_Time = stepnumber - step % -> DISPLAY
end

fclose(temperature);
fclose(energie);

load 'temperature.txt'
load 'energie.txt'

Emean = 0;
Tmean = 0;
EEmean = 0;
Var = 0;

taglio = round(2000/7);

for i=taglio:normalizednumber
    
    Emean = Emean + energie(i)/normalizednumber;
    Tmean = Tmean + temperature(i)/normalizednumber;
    EEmean = EEmean + ((energie(i))^2)/normalizednumber;
       
end

for i=taglio:normalizednumber
    
    Var = Var + (1/normalizednumber) * (Emean - energie(i))^2;
    
end

Errore1 = sqrt(Var)/abs(Emean)

Errore2 = sqrt(EEmean - Emean^2)/abs(Emean)

Temperatura_Media_Finale = Tmean