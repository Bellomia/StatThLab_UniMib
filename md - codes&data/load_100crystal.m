function [x0, y0, z0] = load_100crystal

global nat;
global Sx;
global Sy;
global Sz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load fccseconditerzi.txt %Input da file. Crea la matrice "fccseconditerzi"
x0 = fccseconditerzi(:,1); %Vettore delle x iniziali [(riga, colonna)]
y0 = fccseconditerzi(:,2); %Vettore delle y iniziali [(riga, colonna)]
z0 = fccseconditerzi(:,3); %Vettore delle z iniziali [(riga, colonna)]
nat=numel(x0); %numel restituisce la lunghezza del vettore in ingresso
Sx = 17.64739; %
Sy = 17.64739; % Parametri per le condizioni di Born von Karman (PBC)
Sz = 24.917179;%
%scatter3(x0,y0,z0) %Plot del reticolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
