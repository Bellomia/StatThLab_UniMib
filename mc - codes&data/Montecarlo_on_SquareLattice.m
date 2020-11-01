% Vogliamo costruire un modello per il comportamento degli adsorbati su una
% superficie, utilizzando il metodo Montecarlo alla Metropolis. La
% superficie sar� rappresentata da un reticolo quadrato (lato L, spaziatura
% unitaria), i cui siti potranno essere "pieni" o "vuoti" secondo la
% variabile booleanda occ(i,j). L'interazione tra adsorbati sar� troncata
% ai soli primi vicini (siti adiacenti, nel senso di up, down, right,
% left), l'interazione tra adsorbati e superficie sottostante � condensata
% nella discretizzazione della superficie in un lattice di "posizioni buone"
% e in un conseguente termine additivo costante nell'energia totale del
% sistema (assumiamo sostanzialemente che gli adsorbati stiano sempre nei
% minimi locali definiti dal sottostante reticolo). Allora possiamo porre a
% zero il contributo energetico di interazione tra adsorbati e substrato.

global L
global Nads
global Nvic
global occ

%clear all

% Parametri della superficie

L = 50;
Nads = 1250;
Nvic = 4;
occ = zeros(L,L);

% Riempimento casuale del reticolo

seme = 570; U = 1;
while U ~= 126
seme = seme + 1;
rng(seme);
[occ] = fill_lattice;

% Calcoliamo i vicini

[xvic, yvic] = square_nearest_neighbors_MC;

% Calcoliamo l'Energia Potenziale

[U] = MC_Energy(xvic, yvic);

% A questo punto dobbiamo considerare l'algoritmo Metropolis, adattato al
% nostro sistema:
%
%       - Siamo in una configurazione qualsiasi, e ne conosciamo l'energia.
%
%       - Dobbiamo implementare un cambio di configurazione casuale, in
%         modo che iterandolo sufficientemente, "spanniamo" tutto lo spazio
%         delle configurazioni (dobbiamo rispettare l'ipotesi ergodica).
%         Per farlo estraiamo casualmente (distribuzione uniforme) un sito
%         occupato e un sito vuoto. Scambiandoli la mossa � ergodica!
%
%       - A questo punto si valuta opportunamente il guadagno di energia
%         ottenuto rispetto alla configurazione iniziale, e si "accetta" la
%         mossa se e solo se l'energia � diminuita, oppure se pur essendo
%         aumentata si ha che p = e^(E'-E/KT) < r, dove r � un numero
%         casuale compreso tra 0 e 1 e distribuito uniformemente. Quindi
%         nel caso di E'-E > 0 si accetta probabilisticamente, secondo una
%         distribuzione che garantisce che dopo un certo numero di passi,
%         fissata la T utilizzata per definire p, che le configurazioni
%         vengano accettate secondo la statistica canonica di Boltzmann :D
%
% Dal momento che l'esponenziale di un numero positivo � certamente
% maggiore di uno, la condizione di scelta pu� essere condensata nel
% calcolo di p, secondo la definizione data sopra, e dunque:
%
%       - se r > p rifiuto la mossa e ne riprovo un'altra
%       - se r < p accetto la mossa e reitero ridefinendo E
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

steps = 5*10^5;

for t = 1:steps

    [a,b] = extract_empty(occ); % Estrazione uniformemente distribuita e 
    [c,d] = extract_full(occ);  % indipendente di sito pieno e sito vuoto.
    
    temp1 = occ(a,b);      %
    temp2 = occ(c,d);      % Scambio delle coordinate...
    occ(a,b) = temp2;      %
    occ(c,d) = temp1;      %
    
    % Calcoliamo l'energia della nuova configurazione e quindi il dU:
       
    [U_maybe] = MC_Energy(xvic, yvic);
    dU = U_maybe - U;
    
    % Implementiamo la condizione di Metropolis:
    
    T = 10;                % Temperatura in K
    KB = 1/11603;           % Costante di Boltzmann in eV/K
    p = exp(-dU/(KB*T));    % Peso di Boltzmann
    r = rand;               % Peso uniforme
    
    if r < p
        
        % Aggiorniamo U solo se r < p
        U = U_maybe;
        
    else
        
        % Ripristiniamo la configurazione precedente
        occ(a,b) = temp1;      
        occ(c,d) = temp2;         
        
    end
    
        % Non resta altro che riciclare :)
        
        
     Remaining_Time = round((steps - t)/1000) % DISPLAY
   
end
end

printSquareLattice; % Stampiamo la (una) configurazione di equilibrio
fprintf('Energia di equlibrio: %d eV', U);
