function [U] = MC_Energy(xvic, yvic)

% Termine di hopping: H = - 0.25 eV
% Lista dei primi vicini: [xvic(k,i,j) , yvic(k,i,j)]

global L
global occ
global Nvic

H = - 0.2;
add = 0;

    for i = 1:L
        
        for j = 1:L
            
            if (occ(i,j) == 1) % Solo se il sito è occupato
            
                for k = 1:Nvic % Ciclo su tutti i siti vicini
                    
                    x = xvic(i,j,k);
                    y = yvic(i,j,k);
                    
                    if (occ(x,y) == 1) % Solo se il sito vicino è occupato
                        add = add + H;
                    end   
                    
                end  
                
            end 
            
        end 
        
    end
    
    U = 0.5 * add; % Dobbiamo contare solo una volta le interazioni
    
end

