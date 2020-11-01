%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ATOMI DENTRO IL CUT_OFF: LISTA DEI VICINI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function make_pure_nearlist;

global x0;
global y0;
global z0;
global rc;
global nat;
global nvic;
global ivic; 

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
%           - NOTE BENE: Il labelling in j, cioè l'ordinamento dei vicini 
%             di [i] è a tutti gli effetti stabilito dall'ordinamento ori-
%             ginale; naturalemente ci sono dei "buchi" dovuti al cut-off.
%
% rc = 3 % Possibilità di definire esplicitamente il cut-off
  filestring = sprintf('purenearlist[rc=%d].txt', rc) % File di salvataggio
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nvic = zeros(nat, 1);   % Azzeriamo il vettore {nvic(i)}
ivic = zeros(nat, nat); % Azzeriamo la matrice {ivic(i,j)}

for i=1:nat % Ciclo su ogni atomo

    for j=1:nat % Ciclo su ogni atomo
    
    dx = x0(i)-x0(j);   %
    dy = y0(i)-y0(j);   % Definiamo gli spostamenti cartesiani temporanei
    dz = z0(i)-z0(j);   %

    ddx = dx^2;     %
    ddy = dy^2;     % Definiamo gli spostamenti quadratici temporanei
    ddz = dz^2;     %

    dd = sqrt(ddx + ddy + ddz); % Distanza tra atomo [i] e atomo [j]

        if (dd < rc && dd > 0.001) % Ricorda che i double non sono reali...
                                   % dd > 0 è equivalente a i ~= j :)

            nvic(i) = nvic(i) + 1;
            ivic(i,nvic(i)) = j;

        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A questo punto vogliamo salvare un file con la nostra "lista dei vicini".
% Il formato sarà:
%
% {Label originale atomi:[i]}
%
% {Label vicini di [i]:[j]}       {Label originale #[j]}
% {Label vicini di [i]:[j+1]}     {Label originale #[j+1]}
%              .                                      .
%              .                                      .
%              .                                      .  
% {Label vicini di [i]:[nvic(i)]} {Label originale vicino #[nvic(i)]}
%
%
% {Label originale atomi:[i+1]}
%
% {Label vicini di [i+1]:[j]}       {Label originale vicino #[j]}
% {Label vicini di [i+1]:[j+1]}     {Label originale vicino #[j+1]}
%              .                                      .
%              .                                      .
%              .                                      .  
% {Label vicini di [i+1]:[nvic(i+1)]} {Label originale vicino #[nvic(i+1)]}
%                                    .
%                                    .
%                                    .
% {Label originale atomi:[nat]}
%
% {Label vicini di [nat]:[j]}       {Label originale vicino #[j]}
% {Label vicini di [nat]:[j+1]}     {Label originale vicino #[j+1]}
%              .                                      .
%              .                                      .
%              .                                      .  
% {Label vicini di [nat]:[nvic(nat)]} {Label originale vicino #[nvic(nat)]}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myfile = fopen(filestring, 'w'); %Apertura file in scrittura

for i=1:nat
    
 fprintf(myfile, '%d\n\n', i);
    
  for j=1:nvic(i)

   fprintf(myfile, '%d \t %d\n', j, ivic(i,j));
   % %d:interi; \n:andata a capo
    
  end

  fprintf(myfile, '\n');
  
end
    
fclose(myfile); %Chiusura file.   

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%