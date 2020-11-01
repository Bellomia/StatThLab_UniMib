function [x0, y0, z0] = load_100crystal_Adatom

global nat;
global Sx;
global Sy;
global Sz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load fccseconditerzi_withAdatom.txt 
x0 = fccseconditerzi_withAdatom(:,1); 
y0 = fccseconditerzi_withAdatom(:,2); 
z0 = fccseconditerzi_withAdatom(:,3); 
nat=numel(x0);
Sx = 17.64739; %
Sy = 17.64739; % Parametri per le condizioni di Born von Karman (PBC)
Sz = 90.00000; %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
