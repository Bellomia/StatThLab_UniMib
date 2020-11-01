clear all
clear fig
global x0;
global y0;
global z0;
global rc;
global rp;
global nat;
global nvic;
global ivic;
global U_at;
global U_smoothed;

[x0,y0,z0]=load_100crystal;

myfile = fopen('U_smoothed.txt', 'w');

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
z0(16) = 5;    % Posizione iniziale dell'atomo 16 parecchio innalzata

for i = 1:100
    
    z0(16) = z0(16) - 0.06; % Traslazione dell'atomo 16
    [nvic, ivic] = make_nearlist % Creazione lista dei vicini.
    [U_smoothed] = smoothed_static_energy;  % Calcolo dell'energia statica.
    fprintf(myfile, '%f \t %f \n', z0(16), U_smoothed);
    %fprintf('z0(16) = %f \nU = %f', z0(16), U_smoothed);
        
end

fclose(myfile);

load U_smoothed.txt;
xplot = U_smoothed(:,1);
yplot = U_smoothed(:,2);
plot(xplot, yplot);

load_crystal; % Ripristiniamo il cristallo originale.
