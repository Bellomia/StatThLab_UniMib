function [xvic, yvic] = hexagonal_nearest_neighbors_MC

% Vogliamo creare una lista dei primi vicini per il nostro reticolo, in
% modo che fissata un'energia di hopping (tight binding) per calcolare
% l'energia totale basti sommare il numero di primi vicini di ogni adatomo.
% La lista avrà il seguente formato:
%
%   (xvic, yvic) tensore del quarto ordine, con xvic(i,j,k) che dà il
%   vicino k-esimo del sito (i,j) [Non importa se il sito è occupato o
%   meno, tale condizione verrà implementata per mezzo di occ(i,j) nella
%   funzione che calcola l'energia]. L'ordine dei vicini (il label k) è
%   puramente convenzionale. Per un reticolo esagonale k va da 1 a 6 :)

global L
global Nvic

xvic = zeros(L,L,Nvic);
yvic = zeros(L,L,Nvic);

    for i = 1:L
        
      for j = 1:L
          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
          
         if mod(j,2) == 0 % Per j pari...
             
             
            
            %%%%%%%%%%%%%%%%%% k = 1 %%%%%%%%%%%%%%%%%%%
            
            if i > 1 

                xvic(i,j,1) = i-1;
                yvic(i,j,1) = j;                

            else   
                
                xvic(i,j,1) = L; % Boundary! [Lower i]
                yvic(i,j,1) = j;
                
            end
    
            
            
             %%%%%%%%%%%%%%%%%% k = 2 %%%%%%%%%%%%%%%%%%%
            
            if i < L

                xvic(i,j,2) = i+1;
                yvic(i,j,2) = j;  
                                
            else   
                
                xvic(i,j,2) = 1; % Boundary! [Upper i]
                yvic(i,j,2) = j;
                
            end
                
            
            
             %%%%%%%%%%%%%%%%%% k = 3 %%%%%%%%%%%%%%%%%%%
            
            if i > 1 && j < L 

                xvic(i,j,3) = i-1;
                yvic(i,j,3) = j+1;  
                
                
            elseif i == 1 && j < L 
                
                xvic(i,j,3) = L; % Boundary! [Lower i]
                yvic(i,j,3) = j+1; 
                
            elseif i > 1 && j == L 
                
                xvic(i,j,3) = i-1;
                yvic(i,j,3) = 1; % Boundary! [Upper j]
                
            else   
                
                xvic(i,j,3) = L; % Boundary! [Lower i]
                yvic(i,j,3) = 1; % Boundary! [Upper j]
                
            end
                
            
            
             %%%%%%%%%%%%%%%%%% k = 4 %%%%%%%%%%%%%%%%%%%
            
            if j < L 

                xvic(i,j,4) = i;
                yvic(i,j,4) = j+1;  
                                                
            else   
                
                xvic(i,j,4) = i;
                yvic(i,j,4) = 1; % Boundary! [Upper j]   
                
            end
            
            
            
             %%%%%%%%%%%%%%%%%% k = 5 %%%%%%%%%%%%%%%%%%%
            
            if i > 1 && j > 1

                xvic(i,j,5) = i-1;
                yvic(i,j,5) = j-1;  
                                                
            elseif i == 1 && j > 1
                
                xvic(i,j,5) = L; % Boundary! [Lower i]  
                yvic(i,j,5) = j-1;
                
            elseif i > 1 && j == 1
                
                xvic(i,j,5) = i-1;
                yvic(i,j,5) = L; % Boundary! [Lower j]
                
            else
                
                xvic(i,j,5) = L; % Boundary! [Lower i] 
                yvic(i,j,5) = L; % Boundary! [Lower j] 
                
            end
            
            
            
             %%%%%%%%%%%%%%%%%% k = 6 %%%%%%%%%%%%%%%%%%%
            
            if j > 1

                xvic(i,j,6) = i;
                yvic(i,j,6) = j-1;  
                                                
            else   
                
                xvic(i,j,6) = i;
                yvic(i,j,6) = L; % Boundary! [Lower j] 
                
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            
         else % Per j dispari...
            
            
             
             
            %%%%%%%%%%%%%%%%%% k = 1 %%%%%%%%%%%%%%%%%%%
            
            if i > 1 

                xvic(i,j,1) = i-1;
                yvic(i,j,1) = j;                

            else   
                
                xvic(i,j,1) = L; % Boundary! [Lower i]
                yvic(i,j,1) = j; 
                
            end
    
            
            
             %%%%%%%%%%%%%%%%%% k = 2 %%%%%%%%%%%%%%%%%%%
            
            if i < L 

                xvic(i,j,2) = i+1;
                yvic(i,j,2) = j;  
                                
            else   
                
                xvic(i,j,2) = 1; % Boundary! [Upper i]
                yvic(i,j,2) = j; 
                
            end
             
            
            
             %%%%%%%%%%%%%%%%%% k = 3 %%%%%%%%%%%%%%%%%%%
            
            if j < L 

                xvic(i,j,3) = i;
                yvic(i,j,3) = j+1;  
                                
            else   
                
                xvic(i,j,3) = i; 
                yvic(i,j,3) = 1; % Boundary! [Upper j]
                
            end
                
            
            
             %%%%%%%%%%%%%%%%%% k = 4 %%%%%%%%%%%%%%%%%%%
            
            if i < L && j < L 

                xvic(i,j,4) = i+1;
                yvic(i,j,4) = j+1;  
                
            elseif i == L && j < L 
                
                xvic(i,j,4) = 1; % Boundary! [Upper i]
                yvic(i,j,4) = j+1;
                
            elseif i < L && j == L 
                
                xvic(i,j,4) = i+1;
                yvic(i,j,4) = 1; % Boundary! [Upper j]  
                                                
            else   
                
                xvic(i,j,4) = 1; % Boundary! [Upper i]
                yvic(i,j,4) = 1; % Boundary! [Upper j]   
                
            end
            
            
            
             %%%%%%%%%%%%%%%%%% k = 5 %%%%%%%%%%%%%%%%%%%
            
            if j > 1

                xvic(i,j,5) = i;
                yvic(i,j,5) = j-1;  
                                                
            else   
                
                xvic(i,j,5) = i;
                yvic(i,j,5) = L; % Boundary! [Lower j]   
                
            end
            
            
            
             %%%%%%%%%%%%%%%%%% k = 6 %%%%%%%%%%%%%%%%%%%
            
            if i < L && j > 1

                xvic(i,j,6) = i+1;
                yvic(i,j,6) = j-1;  
                
            elseif i == L && j > 1
                
                xvic(i,j,6) = 1; % Boundary! [Upper i]
                yvic(i,j,6) = j-1; 
                
            elseif i < L && j == 1
                
                xvic(i,j,6) = i+1;
                yvic(i,j,6) = L; % Boundary! [Lower j]
                                                
            else   
                
                xvic(i,j,6) = 1; % Boundary! [Upper i]
                yvic(i,j,6) = L; % Boundary! [Lower j]
                
            end
                     
        end
                            
      end
        
    end
    
end