%GABBIE DI VERLET
%
%I doppi cicli rallentano molto il codice. Già l'utilizzo della lista di
%vicini ci aiuta, ma non è sufficiente. La funzione che calcola i vicini è
%comunque un collo di bottiglia, che fa scalare il codice come nat^2. Tale
%problema può essere aggirato.
%
%Innanzitutto si dovrà aggiungere una condizione nell'if del raccordo
%polinomiale. Cioè che per r > r_cutoff non si debba sommare nulla a
%energia e forze. Questo può aiutare ad evitare il calcolo dei vicini in
%alcuni casi "fortunati". Ammettiamo di NON ricacolare i vicini dopo un
%passo. Se un atomo è uscito dalla "gabbia" dei vicini di un altro atomo 
%fissato) tale condizione fa in modo che pur rimanendo nella lista dei 
%vicini, tale atomo non contribuisca all'energia (né alle forze). I
%problemi naturalmente si hanno se un atomo che era fuori dai vicini entra
%nella "gabbia". In tal caso non essendo in lista non potremmo mai rivelare
%il suo ingresso, e non potremmo contare il suo contributo ad energia e
%forze. Introdciamo un ulteriore raggio notevole, rv, raggio di Verlet. Ad
%esempio rv = rc + 0.3, allora rc sarà il cutoff d'interazione, mentre rv
%sarà il discriminante dei vicini! L'efficacia di tale metodo è basata sul
%confronto tra cammino medio tra due passi e distanza rv-rc! :D
%Naturalmente tutto ciò è pilotato anche da ogni quanto decido di calcolare
%i vicini...più tempo passa e più sarà necessario distanziare rc e rv,
%oppure infittire i passi :) La cosa migliore, considerato il caso peggiore
%(atomo al limite del rv, e atomo fissato, entrambi che si spostano l'uno
%verso l'altro), è richiamare il calcolo dei vicini se e solo se la
%distanza massima percorsa da uno qualsiasi degli atomi è (rv-rc)/2! :D :D
%(la distanza intesa dall'ultima chiamata dei vicini...occhio!). Si vedrà
%che, ovviamente, il numero di chiamate al calcolo vicini cresce con la
%temperatura (gli atomi si muovono di più...le ampiezze di vibrazione
%crescono). La scelta di rv è delicata...se troppo grande di fatto i vicini
%sono tanti e scaliamo ancora come nat^2. Se troppo piccolo chiamiamo
%troppo spesso i vicini e allora scaliamo ancora come nat^2. Se troviamo un
%buon valore possiamo avvicinarci a scalare linearmente su nat :D :D :D