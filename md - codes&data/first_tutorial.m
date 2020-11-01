load fccseconditerzi.txt %Input da file. Crea la matrice "fccseconditerzi"
x0 = fccseconditerzi(:,1); %Vettore delle x iniziali [(riga, colonna)]
y0 = fccseconditerzi(:,2); %Vettore delle y iniziali [(riga, colonna)]
z0 = fccseconditerzi(:,3); %Vettore delle z iniziali [(riga, colonna)]
nat=numel(x0); %numel restituisce la lunghezza del vettore in ingresso.

%%%%%%%%%%%%%%%%%%%
%PLOT DEL RETICOLO%
%%%%%%%%%%%%%%%%%%%


scatter3(x0,y0,z0) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITMO PER TROVARE LA X MASSIMA%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



xmax=-100000; %Siamo sicuri che sia minore di ogni x

for i=1:nat %Cicliamo su tutti gli atomi

    if xmax < x0(i) %Condizione

        xmax = x0(i); %Ridefiniamo xmax se la condizione è verificata

    end

end

xmax == max(x0) %Verifica dell'algoritmo



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TROVARE IL PASSO RETICOLARE DEL CRISTALLO%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Non vogliamo assumere che il reticolo sia di Bravais, per cui di fatto
%dobbiamo trovare la distanza minima tra tutti gli atomi

dmin=100000; %Siamo sicuri sia più grande di tutte le distanze

for i=1:nat %Ciclo su ogni atomo

    for j=i+1:nat %Ciclo su ogni atomo diverso da i (e dalle i precedenti)
    
    dd = sqrt((x0(i)-x0(j))^2 + (y0(i)-y0(j))^2 + (z0(i)-z0(j))^2);

        if dd < dmin

            dmin = dd;

        end
    end
end
    
dmin



%%%%%%%%%%%%%%%%%%%%%%%%%
%ATOMI DENTRO IL CUT_OFF%
%%%%%%%%%%%%%%%%%%%%%%%%%

rc = 3; %Cut-off strategico per contare solo i primi vicini [3Å]

nvic = zeros(nat, 1); %Azzeriamo il vettore {nvic(i)}
ivic = zeros(nat, nat); %Azzeriamo la matrice {ivic(i,j)}

for i=1:nat %Ciclo su ogni atomo

    for j=1:nat %Ciclo su ogni atomo
    
    dx = x0(i)-x0(j);
    dy = y0(i)-y0(j);
    dz = z0(i)-z0(j);

    ddx = dx^2;
    ddy = dy^2;
    ddz = dz^2;

    dd = sqrt(ddx + ddy + ddz);

        if (dd < rc && dd > 0.001) %Ricorda che i double non sono reali...
                                   %dd > 0 è equivalente a i ~= j :)

            nvic(i) = nvic(i) + 1;
            ivic(i,nvic(i)) = j;

        end
    end
end
    
%Chi è il vicino numero 3 dell'atomo 107?
ivic(107, 3) %Deve essere il 101 [OK]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcolo dell'Energia Statica U%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

epsilon = 0.345; %Parametri
sigma = 2.644;   %Fisici

phiLJ = 0; %Inizializzazione della somma
U_at = zeros(nat, 1);

for i=1:nat
    
    phiLJ_prec = phiLJ; %Mi serve per l'if sotto! È SUM{U_at(1:i-1)}

        for j=1:nvic(i)

            dx = x0(i)-x0(ivic(i,j));
            dy = y0(i)-y0(ivic(i,j));
            dz = z0(i)-z0(ivic(i,j));

            ddx = dx^2;
            ddy = dy^2;
            ddz = dz^2;

            dd = sqrt(ddx + ddy + ddz);

            phi12 = (4*epsilon*sigma^12)/dd^12;
            phi6 = (4*epsilon*sigma^6)/dd^6;

                                
            phiLJ = phiLJ + (phi12 - phi6); %NB. Non ci vuole i?j, visto
                                            %che la lista lo incorpora già!
                    
                           
        end  


    if i==1

        U_at(i) = phiLJ;

    else
        
        
        U_at(i)= phiLJ - phiLJ_prec;

    end

      
end

U_tot = 0.5*phiLJ %Deve venire: -705.4144 eV [OK]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Salvataggio su file dei Dati%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Vogliamo salvare un file con la lista dei vicini

myfile = fopen('vicini3.txt', 'w'); %Apertura file in scrittura

for i=1:nat
    

    fprintf(myfile, '%d %d %f\n', i, nvic(i), U_at(i));
    % %d:interi; %f:float; \n:andata a capo
    % Quindi stiamo facendo una tabella con:
    %                                       -Prima colonna: label atomo
    %                                       -Seconda colonna: #vicini
    %                                       -Terza colonna: sua energia
    
end

fclose(myfile); %Chiusura file

%%%%%%%%%%%%%%%
%Plot del file%
%%%%%%%%%%%%%%%

load 'vicini3.txt';

xplot = vicini3(:,1); %[i]
yplot = vicini3(:,2); %[nvic(i)]
eplot = vicini3(:,3); %[U_at(i)]

scatter(xplot, yplot);
hold on %sovrappone i grafici
scatter(xplot, eplot);

%Devono venire "simmetrici" (specchiamento su x, a meno di un ovvio fattore
%di scala), perché U è proporzionale al numero di primi vicini. [OK]
