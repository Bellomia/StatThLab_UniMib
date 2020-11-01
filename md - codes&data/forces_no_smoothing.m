load_crystal;

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
z0(16) = 5;    % Posizione iniziale dell'atomo 16 parecchio innalzata

epsilon = 0.345; % Parametri Fisici
sigma = 2.644;   % di Lennard-Jones

Fx = zeros(nat,1);
Fy = zeros(nat,1);
Fz = zeros(nat,1);

for step = 1:100
    
    z0(16) = z0(16) - 0.06; % Traslazione dell'atomo 16
    make_nearlist;  % Creazione lista dei vicini
    
    for i=1:nat
    
        for j=1:nvic(i) % Lavoriamo solo sui vicini di [i] :D

            dx = x0(i)-x0(ivic(i,j)); % OCCHIO!
            dy = y0(i)-y0(ivic(i,j)); % Vogliamo la distanza fra [i] e il
            dz = z0(i)-z0(ivic(i,j)); % suo VICINO j-esimo...

            ddx = dx^2; %
            ddy = dy^2; % Solito trucco notazionale...
            ddz = dz^2; %

            dd = sqrt(ddx+ddy+ddz); % Distanza Euclidea...
           
            
            add_Fx = 24*epsilon*sigma^6 / dd^8 * dx * (2*sigma^6/dd^6 - 1);
            add_Fy = 24*epsilon*sigma^6 / dd^8 * dy * (2*sigma^6/dd^6 - 1);
            add_Fz = 24*epsilon*sigma^6 / dd^8 * dz * (2*sigma^6/dd^6 - 1);
           
            Fx(i) = Fx(i) + add_Fx;
            Fy(i) = Fy(i) + add_Fy;
            Fz(i) = Fz(i) + add_Fz;
           
       end
       
   end

end