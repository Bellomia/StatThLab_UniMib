function [x,y] = extract_full(occ)

% Estrae casualmente un sito del reticolo, con la condizione che esso sia
% pieno, ossia che occ(x,y) abbia valore "true".

    global L
    global Nads
    
    % Estrazione di un sito casuale con la funzione randi (random intero)
    
    x = randi([1,L]);
    y = randi([1,L]);

    % Verifichiamo che (x,y) sia vuoto, altrimenti ricicliamo fino ad
    % ottenere un sito pieno.
    
    while occ(x,y) ~= 1
            
        x = randi([1,L]);
        y = randi([1,L]); 
        
    end
    
end
