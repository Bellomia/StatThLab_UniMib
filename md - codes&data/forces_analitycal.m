global x0;
global y0;
global z0;
global rc;
global rp;
global nat;
global nvic;
global ivic;
global U_at;
global U_smoothed;

load_crystal;

myfile = fopen('analytical_force16.txt', 'w');

rc = 4.5;      % Valore di cut-off fissato
rp = 4.2;      % Valore di r' fissato
z0(16) = 5;    % Posizione iniziale dell'atomo 16 parecchio innalzata

epsilon = 0.345; % Parametri Fisici
sigma = 2.644;   % di Lennard-Jones

difference = rp - rc;                       
sum = rp + rc;
Epol = 4*epsilon*(sigma^12/(rp)^12 - sigma^6/(rp)^6);
Fpol = 4*epsilon*(-12*sigma^12/(rp)^13 + 6*sigma^6/(rp)^7);
Dpol = Fpol/difference^2 - 2*Epol/difference^3;
Cpol = Fpol/(2*difference) - 3/2*Dpol*sum;
Bpol = -2*Cpol*rc - 3*Dpol*rc^2;
Apol = Cpol*rc^2 + 2*Dpol*rc^3;

for step = 1:100
    
    Fx = zeros(nat,1); %
    Fy = zeros(nat,1); % Bisogna annullare le forze per ogni configurazione
    Fz = zeros(nat,1); %
    
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
           
          if dd < rp || dd > rc
            
            add_Fx = 24*epsilon*sigma^6 / dd^8 * dx * (2*sigma^6/dd^6 - 1);
            add_Fy = 24*epsilon*sigma^6 / dd^8 * dy * (2*sigma^6/dd^6 - 1);
            add_Fz = 24*epsilon*sigma^6 / dd^8 * dz * (2*sigma^6/dd^6 - 1);
            
          else % Serve il Raccordo!

            add_Fx = - (Bpol+2*Cpol*dd+3*Dpol*dd^2)*(dx/dd);
            add_Fy = - (Bpol+2*Cpol*dd+3*Dpol*dd^2)*(dy/dd);
            add_Fz = - (Bpol+2*Cpol*dd+3*Dpol*dd^2)*(dz/dd);             
                
          end
           
        Fx(i) = Fx(i) + add_Fx;
        Fy(i) = Fy(i) + add_Fy;
        Fz(i) = Fz(i) + add_Fz;
           
       end
       
    end

  fprintf(myfile, '%f \t %f \n', z0(16), Fz(16));
    
end

fclose(myfile);

load 'analytical_force16.txt';
xplot = analytical_force16(:,1);
yplot = analytical_force16(:,2);
plot(xplot, yplot);
