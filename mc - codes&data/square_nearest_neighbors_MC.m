function [xvic, yvic] = square_nearest_neighbors_MC

% Vogliamo creare una lista dei primi vicini per il nostro reticolo, in
% modo che fissata un'energia di hopping (tight binding) per calcolare
% l'energia totale basti sommare il numero di primi vicini di ogni adatomo.
% La lista avrà il seguente formato:
%
%   (xvic, yvic) tensore del quarto ordine, con xvic(i,j,k) che dà il
%   vicino k-esimo del sito (i,j) [Non importa se il sito è occupato o
%   meno, tale condizione verrà implementata per mezzo di occ(i,j) nella
%   funzione che calcola l'energia]. L'ordine dei vicini (il label k) è
%   puramente convenzionale. Per un reticolo quadrato k va da 1 a 4 :)

global L
global Nvic

xvic = zeros(L,L,Nvic);
yvic = zeros(L,L,Nvic);

    for i = 1:L
        
        for j = 1:L
            
            %%%%%%%%%%%%%%%%%% k = 1 %%%%%%%%%%%%%%%%%%%
            
            if j < L 

                xvic(i,j,1) = i;
                yvic(i,j,1) = j+1;                

            else   
                
                xvic(i,j,1) = i;
                yvic(i,j,1) = 1; % Boundary! [Upper j]
                
            end
    
             %%%%%%%%%%%%%%%%%% k = 2 %%%%%%%%%%%%%%%%%%%
            
            if j > 1 

                xvic(i,j,2) = i;
                yvic(i,j,2) = j-1;  
                                
            else   
                
                xvic(i,j,2) = i;
                yvic(i,j,2) = L; % Boundary! [Lower j]
                
            end
                
             %%%%%%%%%%%%%%%%%% k = 3 %%%%%%%%%%%%%%%%%%%
            
            if i < L 

                xvic(i,j,3) = i+1;
                yvic(i,j,3) = j;  
                                
            else   
                
                xvic(i,j,3) = 1; % Boundary! [Upper i]
                yvic(i,j,3) = j;
                
            end
                
             %%%%%%%%%%%%%%%%%% k = 4 %%%%%%%%%%%%%%%%%%%
            
            if i > 1 

                xvic(i,j,4) = i-1;
                yvic(i,j,4) = j;  
                                                
            else   
                
                xvic(i,j,4) = L; % Boundary! [Lower i]
                yvic(i,j,4) = j;   
                
            end
                            
        end
        
    end

end

