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

load_crystal;
myfile = fopen('U_smoothed.txt', 'w');

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
z0(16) = 5;    % Posizione iniziale dell'atomo 16 parecchio innalzata

for i = 1:1000
    
    z0(16) = z0(16) - 0.006; % Traslazione dell'atomo 16
    make_nearlist;  % Creazione lista dei vicini.
    smoothed_static_energy;  % Calcolo dell'energia statica.
    fprintf(myfile, '%f \t %f \n', z0(16), U_smoothed);
    %fprintf('z0(16) = %f \nU = %f', z0(16), U_smoothed);
        
end

fclose(myfile);

load U_smoothed.txt;

% Una volta che abbiamo l'energia (regolarizzata) in funzione di z0(16),
% risulta possibile calcolare la forza che agisce sull'atomo [16], lungo
% l'asse z, per mezzo della definizione di derivata. Dal momento che zo(16)
% è una variabile *discreta* sarà possibile utilizzare l'incremento [step]
% per calcolare esplicitamente il rapporto incrementale di [U_smoothed].
%
% Fz = - dU/dz = -[U(z+step)-U(z)]/step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path = length(U_smoothed(:,1)) % "Lunghezza" del percorso dell'atomo [16]
Fz = zeros(path,1);

for i = 2:path % Attenzione a cosa succede ai bordi... (*)
    
    dU = U_smoothed(i,2) - U_smoothed(i-1,2);
    dz = U_smoothed(i,1) - U_smoothed(i-1,1);
    Fz(i) = - dU/dz;
    
end

%(*)
Fz(1) = Fz(2); % Scelta arbitraria del bordo. A priori sarebbe uguale pen-
               % sare di imporre arbitrariamente la derivata al bordo
               % destro o sinistro. Ma dato che conosciamo l'andamento
               % qualitativo della curva (verso la fine del path si avrà
               % una fortissima repulsione per cui l'andamento della forza
               % sarà molto molto sensibile; al contrario all'inizio del
               % path la forza è pressocché costante dato che la maggior
               % parte degli atomi sono fuori dal cut-off! Allora si
               % capisce bene che è più sensato imporre in questa zona la
               % condizione arbitraria...

xplot = U_smoothed(:,1);
yplot = Fz;
plot(xplot, yplot); % [OK!]
