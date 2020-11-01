% Si vuole valutare l'energia statica del cristallo per diversi cut-off.
% Per farlo verrano utilizzati gli script make_nearlist.m e static_energy.m
% in modo che:
%
%               - Venga prodotto, per ogni valore di [rc], un file di testo
%                 con tabulata la "lista dei vicini" corrispondente.
%
%               - Venga prodotto, per ogni valore di [rc], un file di testo
%                 che riporti l'energia totale del cluster di atomi più una
%                 tabella che per ogni atomo specifichi numero dei "vicini"
%                 e energia conseguente. Data la ridotta dimensione della
%                 struttura ci si aspetta una grande variabilità di queste
%                 energie parziali (rottura di simmetria traslazionale).
%
%               - Vengano graficate le tabelle del punto precedente in modo
%                 da poter confrontare in modo semplice i risultati che si
%                 ottengono al crescere di [rc]. Sostanzialmente quel che
%                 ci si aspetta è una crescita improvvisa sia del numero di
%                 vicini che dell'energia per singolo atomo ogni qual volta
%                 il raggio di cut-off si ritrovi ad inglobare una "shell"
%                 nuova di atomi. Si osservi che finanto che [rc] comprende
%                 solo i primi vicini la relazione tra #{vicini} e U_atomo
%                 è LINEARE, per cui a meno di un fattore di scala i due
%                 grafici risultano simmetrici per specchiamento sull'asse
%                 dei label; laddove si "accendano" shell successive si ha
%                 una relazione sicuramente monotòna, ma più complicata.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global x0;
global y0;
global z0;
global rc;
global rp;
global nat;
global nvic;
global ivic;
global U_at;
global U_tot;


load_crystal;
notmyfile = fopen('U_rc.txt', 'w');

rc = 1.5;        % Valore iniziale del cut-off

for i = 0:500
    
    rc = rc + 0.05;  % Incremento per ciclo.
    make_nearlist;  % Creazione lista dei vicini.
    static_energy;  % Calcolo dell'energia.
    fprintf(notmyfile, '%f \t %f \n', rc, U_tot);
        
end

fclose(notmyfile);

load U_rc.txt;
xplot = U_rc(:,1);
yplot = U_rc(:,2);
plot(xplot, yplot);

% Adesso scriviamo un file sintetico che registri l'andamento di [U] al va-
% riare di [rc]: