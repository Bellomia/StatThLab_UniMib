%GABBIE DI VERLET
%
%I doppi cicli rallentano molto il codice. Gi� l'utilizzo della lista di
%vicini ci aiuta, ma non � sufficiente. La funzione che calcola i vicini �
%comunque un collo di bottiglia, che fa scalare il codice come nat^2. Tale
%problema pu� essere aggirato.
%
%Innanzitutto si dovr� aggiungere una condizione nell'if del raccordo
%polinomiale. Cio� che per r > r_cutoff non si debba sommare nulla a
%energia e forze. Questo pu� aiutare ad evitare il calcolo dei vicini in
%alcuni casi "fortunati". Ammettiamo di NON ricacolare i vicini dopo un
%passo. Se un atomo � uscito dalla "gabbia" dei vicini di un altro atomo 
%fissato) tale condizione fa in modo che pur rimanendo nella lista dei 
%vicini, tale atomo non contribuisca all'energia (n� alle forze). I
%problemi naturalmente si hanno se un atomo che era fuori dai vicini entra
%nella "gabbia". In tal caso non essendo in lista non potremmo mai rivelare
%il suo ingresso, e non potremmo contare il suo contributo ad energia e
%forze. Introdciamo un ulteriore raggio notevole, rv, raggio di Verlet. Ad
%esempio rv = rc + 0.3, allora rc sar� il cutoff d'interazione, mentre rv
%sar� il discriminante dei vicini! L'efficacia di tale metodo � basata sul
%confronto tra cammino medio tra due passi e distanza rv-rc! :D
%Naturalmente tutto ci� � pilotato anche da ogni quanto decido di calcolare
%i vicini...pi� tempo passa e pi� sar� necessario distanziare rc e rv,
%oppure infittire i passi :) La cosa migliore, considerato il caso peggiore
%(atomo al limite del rv, e atomo fissato, entrambi che si spostano l'uno
%verso l'altro), � richiamare il calcolo dei vicini se e solo se la
%distanza massima percorsa da uno qualsiasi degli atomi � (rv-rc)/2! :D :D
%(la distanza intesa dall'ultima chiamata dei vicini...occhio!). Si vedr�
%che, ovviamente, il numero di chiamate al calcolo vicini cresce con la
%temperatura (gli atomi si muovono di pi�...le ampiezze di vibrazione
%crescono). La scelta di rv � delicata...se troppo grande di fatto i vicini
%sono tanti e scaliamo ancora come nat^2. Se troppo piccolo chiamiamo
%troppo spesso i vicini e allora scaliamo ancora come nat^2. Se troviamo un
%buon valore possiamo avvicinarci a scalare linearmente su nat :D :D :D