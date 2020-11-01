function [x0, y0, z0] = load_111crystal_Adatom

global nat;
global Sx;
global Sy;
global Sz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load fcc111.txt %Input da file. Crea la matrice "fccseconditerzi"
x0 = fcc111(:,1); %Vettore delle x iniziali [(riga, colonna)]
y0 = fcc111(:,2); %Vettore delle y iniziali [(riga, colonna)]
z0 = fcc111(:,3); %Vettore delle z iniziali [(riga, colonna)]
nat=numel(x0); %numel restituisce la lunghezza del vettore in ingresso
Sx = 11.766256838944152; %
Sy = 20.379754659956042; % Parametri per le PBC
Sz = 280.821325437946118; %
%scatter3(x0,y0,z0,400) %Plot del reticolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
