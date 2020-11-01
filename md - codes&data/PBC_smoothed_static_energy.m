%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcolo dell'energia cristallina U[z(16)]: Curva di Lennard-Jones %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% del cluster. Per eliminare la discontinuità che inevitabilmente si ha per
% z(16) troppo grande (sostanzialmente quando i primi vicini dell'atomo 16
% si allontanano oltre il cutoff...) sostituiamo la nostra energia LJ, tra
% [rc] e un opportuno [rp], con un raccordo polinomiale di grado III.
%
% Si implementano qui anche le condizioni di Born von Karman per simulare
% il bulk, per cui definite (nel main) Sx Sy e Sz, dimensioni della cella
% da replicare si rimaneggieranno le distanze tra gli atomi in modo da
% costruire delle opportune "immagini" degli atomi del cluster, con i quali
% fare interagire gli atomi reali (il cut-off ci permette di lavorare in
% questo modo, dal momento che atomi troppo lontani possono essere
% trascurati...). Per una discussione dettagliata guarda le relative slides
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [U_smoothed] = smoothed_static_energy

global x0;
global y0;
global z0;
global rc;
global rp;
global nat;
global nvic;
global ivic;
global U_at;
global Apol;
global Bpol;
global Cpol;
global Dpol;
global epsilon;
global sigma;
global Sx;
global Sy;
global Sz;

phiLJ = 0;              % Inizializzazione della somma
U_at = zeros(nat, 1);   % Inizializzazione del vettore [U_at(i)]


for i=1:nat
    
    phiLJ_prec = phiLJ; % Mi serve per l'else sotto: è SUM{U_at(1:i-1)}!

        for j=1:nvic(i) % Lavoriamo solo sui vicini di [i] :D

            dx = x0(i)-x0(ivic(i,j)); % OCCHIO!
            dy = y0(i)-y0(ivic(i,j)); % Vogliamo la distanza fra [i] e il
            dz = z0(i)-z0(ivic(i,j)); % suo VICINO j-esimo...
            
            % Inoltre siamo interessati ad applicare le condizioni al contorno
            % periodiche (PBC) per cui rimaneggiamo le distanze cartesiane
            % secondo il metodo delle immagini della cella [cella Sx,Sy,Sz]
        
            dx = dx - Sx*round(dx/Sx);
            dy = dy - Sy*round(dy/Sy);
            dz = dz - Sz*round(dz/Sz);            

            ddx = dx^2; %
            ddy = dy^2; % Solito trucco notazionale...
            ddz = dz^2; %

            dd = sqrt(ddx + ddy + ddz); % Distanza Euclidea...
           
          
          if dd < rp % "Zona sicura" 

            phi12 = (4*epsilon*sigma^12)/dd^12; % Termine repulsivo
            phi6 = (4*epsilon*sigma^6)/dd^6;    % Termine attrattivo              
              
            phiLJ = phiLJ + (phi12 - phi6); % Somma di Lennard-Jones

          elseif dd > rc % Necessario per le Gabbie di Verlet

            phiLJ = phiLJ;
            
          else % Zona da raccordare 

            polinomio = Apol + Bpol*dd + Cpol*dd^2 + Dpol*dd^3;
              
            phiLJ = phiLJ + polinomio; % Somma del termine smoothed
              
          end
                           
        end  
        
   U_at(i)= phiLJ - phiLJ_prec; % phiLJ_prec è inizializzato a zero :)
   
end

U_smoothed = 0.5*phiLJ; % Il fattore 1/2 tiene conto di phi(i,j) == phi(j,i)

end