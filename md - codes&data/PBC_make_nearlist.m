%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATOMI DENTRO IL CUT_OFF: LISTA DEI VICINI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nvic, ivic] = make_nearlist

global x0;
global y0;
global z0;
global rv;
global nat;
global Sx;
global Sy;
global Sz;


% Per ogni atomo si vuole definire un insieme di "atomi vicini" per mezzo 
% di un opportuno raggio di cut-off [rc], oltre il quale trascurare
% l'interazione (Lennard-Jones). A partire dalle coordinate atomiche date
% [x0(i), y0(i), z0(i)], labellate in ordine casuale in i, si vogliono 
% ottenere:
%           - un vettore [nvic(i)] che ad ogni atomo [i] associ il numero 
%             il numero di suoi "vicini", ossia di atomi entro rc da esso.
%             Naturalmente non si dovrà contare l'atomo i-esimo stesso...
%
%           - un tensore [ivic(i,j)] che per ogni atomo [i] e per ogni suo
%             vicino [j] indica il label originale di [j]. Questa, sostan-
%             zialmente è la "LISTA DEI VICINI". 
%
%           - NOTE BENE: Il labelling in j, cioé l'ordinamento dei vicini 
%             di [i] è a tutti gli effetti stabilito dall'ordinamento ori-
%             ginale; naturalemente ci sono dei "buchi" dovuti al cut-off.
%
% rc = 3 %Possibilità di definire esplicitamente il cut-off
% filestring = sprintf('nearlist[rc=%d].txt', rc); % File di salvataggio
%
%
% È stato implementato anche il "trucco delle gabbie di Verlet" per
% snellire il codice, per cui nel creare la lista dei vicini si utilizzerà
% un raggio di cut-off maggiorato [rv] rispetto al cut-off effettivamente
% utilizzato nel calcolo di energia e forze [rc]. Vedi 'Gabbie_di_Verlet.m'
% 
% Inoltre sono state implementate le condizioni di Born von Karman per
% simulare un bulk infinito tramite il metodo delle immagini della cella.
% Sx, Sy e Sz sono i parametri cruciali a tale scopo. [Guarda slide]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nvic = zeros(nat, 1);   % Azzeriamo il vettore {nvic(i)}
ivic = zeros(nat, nat); % Azzeriamo la matrice {ivic(i,j)}

for i=1:nat % Ciclo su ogni atomo

    for j=1:nat % Ciclo su ogni atomo
    
    dx = x0(i)-x0(j);           % Calcolo degli spostamenti cartesiani
    dx = dx - Sx*round(dx/Sx);  % che tengano conto delle "immagini" degli
    dy = y0(i)-y0(j);           % atomi, prodotte dalle condizioni al 
    dy = dy - Sy*round(dy/Sy);  % contorno periodiche (PBC). round(x) dà
    dz = z0(i)-z0(j);           % l'intero più vicino al numero reale x.
    dz = dz - Sz*round(dz/Sz);  % Sx Sy Sz sono le dimensioni della cella.

    ddx = dx^2;     %
    ddy = dy^2;     % Definiamo gli spostamenti quadratici temporanei
    ddz = dz^2;     %

    dd = sqrt(ddx + ddy + ddz); % Distanza tra atomo [i] e atomo [j]

        if (dd < rv && dd > 0.001) % Ricorda che i double non sono reali...
                                   % dd > 0 è equivalente a i ~= j :)

            nvic(i) = nvic(i) + 1;
            ivic(i,nvic(i)) = j;

        end
    end
end

% Ciò che segue è commentato perchè non strettamente necessario e
% dispendioso in termini di tempo di esecuzione, visto che il codice di
% dinamica molecolare chiama ripetutamente questa funzione.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A questo punto vogliamo salvare un file con la nostra "lista dei vicini".
% Il formato sarà:
%
% {Atom Nr.[i]}
%
% {Distance label: [j]}       {Original Label: [j]}
% {Distance label: [j+1]}     {Original Label: [j+1]}
%              .                         .
%              .                         .
%              .                         .  
% {Distance label: [nvic(i)]} {Original Label: [nvic(i)]}
%
%
% {Atom Nr.[i+1]}
%
% {Distance label: [j]}       {Original Label: [j]}
% {Distance label: [j+1]}     {Original Label: [j+1]}
%              .                         .
%              .                         .
%              .                         .  
% {Distance label: [nvic(i+1)]} {Original Label: [nvic(i+1)]}
%                              .
%                              .
%                              .
% {Atom Nr.[nat]}
%
% {Distance label: [j]}       {Original Label: [j]}
% {Distance label: [j+1]}     {Original Label: [j+1]}
%              .                         .
%              .                         .
%              .                         .  
% {Distance label: [nvic(nat)]} {Original Label: [nvic(nat)]}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
myfile = fopen(filestring, 'w'); %Apertura file in scrittura

for i=1:nat
    
 fprintf(myfile, 'Atom Nr.%d\n\n', i);
    
  for j=1:nvic(i)

   fprintf(myfile, 'Distance label: %d \t\t Original label: %d\n', j, ivic(i,j));
   % %d:interi; \n:andata a capo
    
  end

  fprintf(myfile, '\n');
  
end
    
fclose(myfile); %Chiusura file. 
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end