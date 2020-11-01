%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcolo dell'Energia Statica U %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Posto che esista la "lista dei vicini" [rc,nvic(i),ivic(i,j)], la sfrut-
% tiamo per calcolare in maniera efficiente l'energia statica del cristallo
% nella sua configurazione di equilibrio (cioè a passo reticolare fissato).
% In sostanza si utilizzerà l'espressione di Lennard-Jones per valutare i 
% singoli termini di interazione, e si sommerranno solo quelli non nulli
% rispetto al cut-off scelto. Tale somma verrà portata avanti ciclando su
% ogni atomo secondo l'ordinamento originale [x0(i), yo(i), z0(i)], e per
% ogni [i] si procederà per vettore vicini [ivic(i, nvic(i)]. Per comodità
% si terrà traccia anche delle singole energie [U_at(i)], non tutte uguali
% in virtù dell'interruzione della simmetria traslazionale alle superfici 
% del cluster.

function static_energy

global x0;
global y0;
global z0;
global nat;
global nvic;
global ivic;
global U_at;
global U_tot;

epsilon = 0.345; % Parametri Fisici
sigma = 2.644;   % di Lennard-Jones

phiLJ = 0;              % Inizializzazione della somma
U_at = zeros(nat, 1);   % Inizializzazione del vettore [U_at(i)]

for i=1:nat
    
    phiLJ_prec = phiLJ; % Mi serve per l'else sotto: è SUM{U_at(1:i-1)}!

        for j=1:nvic(i) % Lavoriamo solo sui vicini di [i] :D

            dx = x0(i)-x0(ivic(i,j)); % OCCHIO!
            dy = y0(i)-y0(ivic(i,j)); % Vogliamo la distanza fra [i] e il
            dz = z0(i)-z0(ivic(i,j)); % suo VICINO j-esimo...

            ddx = dx^2; %
            ddy = dy^2; % Solito trucco notazionale...
            ddz = dz^2; %

            dd = sqrt(ddx + ddy + ddz); % Distanza Euclidea...

            phi12 = (4*epsilon*sigma^12)/dd^12; % Termine repulsivo
            phi6 = (4*epsilon*sigma^6)/dd^6;    % Termine attrattivo

                                
          % OCCHIO!
          % Non ci vuole i ~= j, visto che la lista lo incorpora già!
            
            phiLJ = phiLJ + (phi12 - phi6);      
                           
        end  


    if i==1

        U_at(i) = phiLJ; % L'energia del primo atomo è semplicemente phiLJ

    else
        
        
        U_at(i)= phiLJ - phiLJ_prec; % Attenzione invece agli altri atomi!

    end

      
end

U_tot = 0.5*phiLJ; % Il fattore 1/2 tiene conto di phi(i,j) == phi(j,i)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Salvataggio su file dei dati ottenuti %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vogliamo salvare una semplice tabella che per ogni atomo - al solito in
% label originali - indichi il numero di primi vicini e l'energia che ne
% consegue. Tali valori naturalmente dipendono dal cut-off considerato. 
%{
myfile = fopen(sprintf('static_energies[rc=%d].txt', rc), 'w');

fprintf(myfile, 'TOTAL CRYSTAL STATIC ENERGY FOR A CUT-OFF OF %f Å\nU = %f eV\n\n', rc, U_tot);
fprintf(myfile, 'Atomic Label \t Number of Significant Neighbors \t Single Atom Energy\n\n'); 

for i=1:nat    

    fprintf(myfile, '%d \t %d \t %f\n', i, nvic(i), U_at(i));
    % %d:interi; %f:float; \n:andata a capo
    % Quindi stiamo facendo una tabella con:
    %                                       -Prima colonna: label atomo
    %                                       -Seconda colonna: #vicini
    %                                       -Terza colonna: energia i-esima

    
  % Salviamo nello stack le colonne (per plottarle)
    xplot(i) = i;
    yplot(i) = nvic(i);
    uplot(i) = 100*U_at(i);
    
end

fclose(myfile); %Chiusura file

%%%%%%%%%%%%%%%%%
% Plot del file %
%%%%%%%%%%%%%%%%%

%scatter(xplot, yplot);
%hold on
%scatter(xplot, uplot);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end