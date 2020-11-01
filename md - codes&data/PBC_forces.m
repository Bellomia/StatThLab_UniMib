function [Fx, Fy, Fz] = forces

global x0;
global y0;
global z0;
global rc;
global rp;
global nat;
global nvic;
global ivic;
global Apol;
global Bpol;
global Cpol;
global Dpol;
global epsilon;
global sigma;
global Sx;
global Sy;
global Sz;

    
Fx = zeros(nat,1); %
Fy = zeros(nat,1); % Bisogna annullare le forze per ogni configurazione
Fz = zeros(nat,1); %
    

  for i=1:nat
    
      for j=1:nvic(i) % Lavoriamo solo sui vicini di [i] :D

        dx = x0(i)-x0(ivic(i,j)); % OCCHIO!
        dy = y0(i)-y0(ivic(i,j)); % Vogliamo la distanza fra [i] e il
        dz = z0(i)-z0(ivic(i,j)); % suo VICINO j-esimo...
        
        % Inoltre siamo interessati ad applicare le condizioni al contorno
        % periodiche (PBC) per cui rimaneggiamo le distanze cartesiane
        % secondo il metodo delle immagini della cella [cella Sx,Sy,Sz]
        
        dx = dx - Sx*round(dx/Sx);
        dy = dy - Sy*round(dy/Sy);
        dz = dz - Sz*round(dz/Sz);

        ddx = dx^2; %
        ddy = dy^2; % Solito trucco notazionale...
        ddz = dz^2; %

        dd = sqrt(ddx+ddy+ddz); % Distanza Euclidea...
           
          if dd < rp
            
            add_Fx = 24*epsilon*sigma^6 / dd^8 * dx * (2*sigma^6/dd^6 - 1);
            add_Fy = 24*epsilon*sigma^6 / dd^8 * dy * (2*sigma^6/dd^6 - 1);
            add_Fz = 24*epsilon*sigma^6 / dd^8 * dz * (2*sigma^6/dd^6 - 1);
            
          elseif dd > rc
              
            add_Fx = 0; %
            add_Fy = 0; % Necessario esplicitarlo per le gabbie di Verlet!
            add_Fz = 0; % 
            
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

end
