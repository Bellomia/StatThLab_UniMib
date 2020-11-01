function printSquareLattice

% Plottiamo il reticolo secondo la seguente convenzione: siti pieni danno
% pallini colorati, siti vuoti danno pallini vuoti. Semplice.

    global L
    global Nads
    global occ
    
    hold on
        
    for i = 1:L
        
        for j = 1:L
            
            if occ(i,j) == 1
                
                scatter(i, j, 100, 'filled', 'MarkerEdgeColor',[0.7, 0, 0], 'MarkerFaceColor', 'r', 'LineWidth', 0.5);
                
            else
                
                scatter(i, j, 5, '+', 'k');
                
            end
                       
        end
        
    end

end