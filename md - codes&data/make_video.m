% Video

load traiettorie.txt

video = VideoWriter('video', 'Uncompressed avi');
video.FrameRate = 25; % fps
open(video);
s = ones(size(x0,1),1) * 475; % Raggio metallico di Ag

for t = 1:stepnumber
       
    if mod(t,10) == 0
    
    shift = (t-1)*nat;
    
    cristallo = traiettorie(1+shift:nat+shift,:);
    
    scatter3(cristallo(:,2),cristallo(:,3),cristallo(:,4), s,'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .60]);
    
    axis([-10 30 -10 30 -30 5]);
    
    print('-dpng','-r300','plot.png');
    fotogramma = imread('plot.png');     % Catturo fotogramma per video
    %fotogramma = getframe(gcf);        % Catturo fotogramma per video
    writeVideo(video, fotogramma);
    
    end
    
    % Stampiamo il conto alla rovescia
    
    Remaining_Time = stepnumber - t
    
end

close(video);