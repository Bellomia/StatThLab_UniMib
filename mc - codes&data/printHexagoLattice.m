function printHexagoLattice

% Plottiamo il reticolo secondo la seguente convenzione: siti pieni danno
% pallini colorati, siti vuoti danno pallini vuoti. Semplice.

    global L
    global Nads
    global occ
    
    hold on
        
    for i = 1:L
        
        for j = 1:L
            
            if occ(i,j) == 1
                
                if mod(j,2) == 0
                
                    scatter(i, j*0.5*sqrt(3), 100, 'filled', 'MarkerEdgeColor',[0.7, 0, 0], 'MarkerFaceColor', 'r', 'LineWidth', 0.5);
                
                else
                    
                    scatter(i+0.5, j*0.5*sqrt(3), 100, 'filled', 'MarkerEdgeColor',[0.7, 0, 0], 'MarkerFaceColor', 'r', 'LineWidth', 0.5);
                    
                end
                
            else
                
                if mod(j,2) == 0
                
                    scatter(i, j*0.5*sqrt(3), 5, 'o', 'k');
                
                else
                    
                    scatter(i+0.5, j*0.5*sqrt(3), 5, 'o', 'k');
                    
                end
                
            end
                       
        end
        
    end
    
    hold off

end