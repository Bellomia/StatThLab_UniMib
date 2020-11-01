function [occ] = fill_lattice

% Riempie il reticolo di Nads adsorbati, cioè riempie la matrice occ(i,j) di
% Nads valori "true" (gli altri restano "false"). La configurazione che
% verrà prodotta è pseudo-casuale, secondo il seme impostato nel main.

    global L
    global Nads
    
    x = 0;
    y = 0;

% Inizializzazione del reticolo

    Nfull = 0; 
    
    occ = zeros(L,L);

    while Nfull < Nads 
    
        [x,y] = extract_empty(occ);               
        occ(x,y) = occ(x,y) + 1;
        Nfull = Nfull + 1;
    
    end

end

