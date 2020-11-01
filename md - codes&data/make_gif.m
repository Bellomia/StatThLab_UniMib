% Video

%load traiettorie.txt

filename = 'Traiettorie.gif';
s = ones(nat-1,1) * 15; % Raggio metallico di Ag

for t = 1:stepnumber
       
    if mod(t,50) == 0 
    
        shift = (t-1)*nat;
    
        cristallo = traiettorie(1+shift:nat+shift,:);
                     
        scatter3(cristallo(2:nat,2),cristallo(2:nat,3),cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
    
    hold on
    %{
        scatter3(cristallo(2:nat,2)+Sx,cristallo(2:nat,3),cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2)-Sx,cristallo(2:nat,3),cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2),cristallo(2:nat,3)+Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2),cristallo(2:nat,3)-Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2)+Sx,cristallo(2:nat,3)+Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);    
        scatter3(cristallo(2:nat,2)+Sx,cristallo(2:nat,3)-Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2)-Sx,cristallo(2:nat,3)-Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
        scatter3(cristallo(2:nat,2)-Sx,cristallo(2:nat,3)+Sy,cristallo(2:nat,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]); 
    %}
           
        scatter3(cristallo(1,2),cristallo(1,3),cristallo(1,4), 15,'MarkerEdgeColor','k',...
        'MarkerFaceColor', [1 .5 0] ); %[1 .5 0]  
      
        axis equal    
        axis([-100 80 -100 80 -80 80]); 
        %axis([-10 30 -10 30 -30 15]); % 100
        %axis([-25 35 -25 35 -30 30]); % 111
    
        print('-dpng','-r300','plot.png');
        fotogramma = imread('plot.png');     % Catturo fotogramma per video
    
        [gif,map] = rgb2ind(fotogramma, 256);
    
        if t == 50 % Cioè il primo frame
        
            imwrite(gif, map, filename, 'gif', 'LoopCount', Inf);
        
        else
        
            imwrite(gif, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0);
    
        end
        
        % Stampiamo il conto alla rovescia
    
        Remaining_Time = stepnumber - t
        clf;
    
    end
            
end