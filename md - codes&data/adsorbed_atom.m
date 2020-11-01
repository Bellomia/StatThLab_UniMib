

load_100crystal;
notmyfile = fopen('U_ads.txt', 'w');

rc = 3       % Valore di cut-off che seleziona i primi vicini
z0(16) = 5    % Posizione iniziale dell'atomo 16 parecchio innalzata

for i = 1:100
    
    z0(16) = z0(16) - 0.06 % Traslazione dell'atomo 16
    make_nearlist;  % Creazione lista dei vicini.
    static_energy;  % Calcolo dell'energia.
    fprintf(notmyfile, '%f \t %f \n', z0(16), U_tot);
    fprintf('z0(16) = %f', z0(16));
        
end

fclose(notmyfile);

load U_ads.txt;
xplot = U_ads(:,1);
yplot = U_ads(:,2);
plot(xplot, yplot);

% Adesso scriviamo un file sintetico che registri l'andamento di [U] al va-
% riare di [rc]: