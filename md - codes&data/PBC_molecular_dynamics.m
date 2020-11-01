%clear all
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
global Sx;
global Sy;
global Sz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
rv = 4.5;      % Raggio per le gabbie di Verlet (4.8)

epsilon = 0.345; % Parametri Fisici
sigma = 2.644;   % di Lennard-Jones

mass = 108*1.66e-27/16;  % Massa in eV/c^2, c in Å/s
KB = 1/11603;            % Costante di Boltzmann in eV/K

difference = rp - rc;                       
sum = rp + rc;
Epol = 4*epsilon*(sigma^12/(rp)^12 - sigma^6/(rp)^6);
Fpol = 4*epsilon*(-12*sigma^12/(rp)^13 + 6*sigma^6/(rp)^7);
Dpol = Fpol/difference^2 - 2*Epol/difference^3;
Cpol = Fpol/(2*difference) - 3/2*Dpol*sum;
Bpol = -2*Cpol*rc - 3*Dpol*rc^2;
Apol = Cpol*rc^2 + 2*Dpol*rc^3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for beat = 1:10

[x0, y0, z0] = load_100crystal;

[nvic, ivic] = PBC_make_nearlist;

[U_smoothed] = PBC_smoothed_static_energy;
    
[Fx, Fy, Fz] = PBC_forces;

seed = 190915;
rng(seed);                  % Inizializzazione generatore random [rand]
T0 = beat*30                  % Temperatura Iniziale in Kelvin

[vx0, vy0, vz0] = speed_extraction; % Condizione Iniziale, fissata T0
[vx0, vy0, vz0] = speed_correction(vx0, vy0, vz0); % Coordinate interne e rinormalizzazione

dt = 7*10^(-15); % step temporale
stepnumber = round(1000); % Numero di step affinché il tempo totale sia 12 ps
taglio = round(2000/7); % Buttiamo via i primi 2 ps dalle medie temporali

temperature = fopen('temperature.txt', 'w');
energie = fopen('energie.txt', 'w');
traiettorie = fopen('traiettorie.txt', 'w');

xv = x0;        %
yv = y0;        % Posizioni salvate per le Gabbie di Verlet
zv = z0;        %

ncall = 1;  % Numero di chiamate a make_nearlist

dd = zeros(1,nat);

hold on 

tic;

for step = 1:stepnumber
    
    for i = 1:nat
        
        x0(i) = x0(i) + vx0(i)*dt + 1/2*(Fx(i)/mass)*dt^2;
        y0(i) = y0(i) + vy0(i)*dt + 1/2*(Fy(i)/mass)*dt^2;
        z0(i) = z0(i) + vz0(i)*dt + 1/2*(Fz(i)/mass)*dt^2;
        
        fprintf(traiettorie, '%d \t %f \t %f \t %f \n', i, x0(i), y0(i), z0(i));

        dx = x0(i)-xv(i); %
        dy = y0(i)-yv(i); % Distanze dalla "posizione di Verlet" salvata
        dz = z0(i)-zv(i); %
        
        % Rimaneggiamo le distanze per poter applicare le PBC [bulk]
        
        dx = dx - Sx*round(dx/Sx);  %
        dy = dy - Sy*round(dy/Sy);  % Sx,Sy,Sz: Cella da replicare...
        dz = dz - Sz*round(dz/Sz);  %      

        dd(i) = sqrt(dx*dx + dy*dy + dz*dz);
        
    end

    fprintf(traiettorie, '\n\n\n'); % Stiamo scrivendo il tensore traiet-
                                    % torie a "fogli". Una matrice nat x 4
                                    % per ogni step. Tra una matrice e
                                    % l'altra lasciamo tre newline...in
                                    % tutto avremo "stepnumber" matrici
                                    % impilate verticalmente.
    
    oldFx = Fx;
    oldFy = Fy;
    oldFz = Fz;
    

    if max(dd) > 0.4*(rv-rc)
        
        [nvic, ivic] = PBC_make_nearlist;

        xv = x0;    %
        yv = y0;    % Posizioni risalvate per le Gabbie di Verlet
        zv = z0;    %

        ncall = ncall + 1; % Numero di chiamate a make_nearlist
    
    end

    [Fx, Fy, Fz] = PBC_forces;
    
    for i = 1:nat
        
        vx0(i) = vx0(i) + ((Fx(i)+oldFx(i))/(2*mass))*dt;
        vy0(i) = vy0(i) + ((Fy(i)+oldFy(i))/(2*mass))*dt;
        vz0(i) = vz0(i) + ((Fz(i)+oldFz(i))/(2*mass))*dt;
        
    end
    
    % VERIFICA

    vv = 0;

    for i=2:nat

        vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
    end

    Ekin = 0.5*mass*vv;
    Tf = 2/3*(Ekin/KB); 
    
    fprintf(temperature, '%f\n', Tf);
    
    [U_smoothed] = PBC_smoothed_static_energy;
    ENERGY = U_smoothed + Ekin*nat; % Ekin è l'energia media!

    fprintf(energie, '%f\n', ENERGY);
    
    Remaining_Time = (stepnumber - step) % -> DISPLAY
    
    x(step) = x0(1);
    y(step) = y0(1);
    z(step) = z0(1);
    
end

ComplessitaComputazionale = toc;

hold off

fclose(temperature);
fclose(energie);

load 'temperature.txt'
load 'energie.txt'

Tmean = 0;
Emean = 0;
EEmean = 0;
Var = 0;

Z = length(2*taglio:stepnumber);

for i=2*taglio:stepnumber
    
    Tmean = Tmean + temperature(i)/Z;
    Emean = Emean + energie(i)/Z;
    EEmean = EEmean + energie(i)^2 * 1/Z;
    
end

for i=2*taglio:stepnumber
    
    Var = Var + (1/Z) * (Emean - energie(i))^2;
    
end

Errore = sqrt(Var)/abs(Emean)
Tmean

Ascissa(beat) = Tmean; 
TicToc(beat) = ComplessitaComputazionale;
NumChiamate(beat) = ncall;

end

scatter(Ascissa,NumChiamate);
hold on
scatter(Ascissa,TicToc);

%{
scatter(Ascissa,NumChiamate)
hold on 
scatter(AscissaV, NumChiamateV)
scatter(Ascissa,TicToc)
hold on 
scatter(AscissaV, TicTocV)

%}

%plot3(x,y,z);

%pause;

%scatter(taglio:stepnumber,energie(taglio:stepnumber));

%pause;

%scatter(1:stepnumber,temperature);