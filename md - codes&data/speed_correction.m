function [vx0, vy0, vz0] = speed_correction(vx0, vy0, vz0)

global nat
global T0
global mass

vCMx=0;
vCMy=0;
vCMz=0;

   for i=1:nat
   
       vCMx = vCMx + vx0(i)/nat;
       vCMy = vCMy + vy0(i)/nat;
       vCMz = vCMz + vz0(i)/nat;
    
   end

   vv = 0;
    
   for i=1:nat
   
       vx0(i) = vx0(i) - vCMx;
       vy0(i) = vy0(i) - vCMy;
       vz0(i) = vz0(i) - vCMz;
       vv = vv + (vx0(i)^2+vy0(i)^2+vz0(i)^2)/nat;
    
   end
   
   KT = T0/11603;
   Ekin = 0.5*mass*vv;         % Teorema di Equipartizione
   T_eff = 2/3*(Ekin/KT)*T0;


   for i=1:nat
   
       vx0(i) = vx0(i)*sqrt(T0/T_eff);
       vy0(i) = vy0(i)*sqrt(T0/T_eff);
       vz0(i) = vz0(i)*sqrt(T0/T_eff);
   
   end
   
end