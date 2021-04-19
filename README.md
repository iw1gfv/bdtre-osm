Introduzione alla mappa BDTRE-OSM del Piemonte
==============================================

1. Panoramica
-----------

La mappa BDTRE-OSM del Piemonte è una mappa sinottica che utilizza i dati del BDTRE della Regione Piemonte e OSM (Openstreetmap.org).

La base topografica è derivata dal BDTRE 2021 (aggiornato al 28/02/2021).

Da una prima analisi dei dati del BDTRE, alcune caratteristiche sono mancanti e/o non pienamente utilizzabili ed allora si implementano in parte con i dati di OSM che sono recenti ma anche incompleti (specialmente in alcune zone).

In pratica la mappa di OSM è trasparente, con lo sfondo del BDTRE.

La sinossi di tempi mostra le stesse caratteristiche provenienti da entrambi i set di dati: una strada può apparire come una fascia colorata (un poligono, preso dal BDTRE) con una striscia di diverso colore a seconda del tipo posta su di essa (tratto da OSM).
Ciò può essere fonte di confusione, soprattutto se le caratteristiche non vanno a sovrapporsi correttamente.


Il BDTRE sostituisce le vecchie CTR, contiene caratteristiche che sono ancora da implementare o inesistenti, i dati sono spesso ricavati da ortofoto di varia data ed altre interpretazioni,voli, ecc..... in alcuni casi sono quindi passibili di errori non ancora del tutto risolti.
Non fare affidamento sulle caratteristiche della carta avente una rappresentazione diversa nella realtà!
Ci si potrebbe perdere o finire in posti pericolosi e/o non essere in grado di arrivare a destinazione.
Non vi è nessuna garanzia riguardo alla correttezza dei dati.


Questa è una mappa specialistica perché punta ad essere molto dettagliata ed ha caratteristiche che portano a un uso più informale: per esempio, le curve di livello sono molto dense (10m di distanza). Il grande dettaglio è buono per gli escursionisti, che sono il pubblico principale per la mappa, ma dovrebbe anche essere utile per i cartografi sul campo per rilevi e/o verifiche.


2. Installazione e utilizzo
---------------------------

La mappa è pensata per dispositivi mobili con sistema operativo Android e dispositivi Gps Garmin serie Gpsmap 64ST (per il quale è stato sviluppato inizialmente). I test hanno dimostrato che può essere visualizzato anche su altri dispositivi.

La mappa in versione Garmin (il file gmapsupp.img) deve essere messo in una cartella denominata 'Garmin' sulla scheda micro SD e poi inserita nell'apposito slot all'interno del dispositivo. E' inoltre possibile caricare direttamente il file sulla scheda sd collegando il dispositivo al PC con l'apposito cavo in dotazione al dispositivo. Ovviamente la velocità di trasmissione sarà notevolmente più bassa.
Quando il dispositivo GPS viene acceso, viene visualizzata sullo schermo la schermata con le informazioni sulla licenza.
La mappa è abbastanza grande e ci vorrà un momento prima di essere caricata.
Un sacco di dettagli sono visibili solo ad un alto livello di zoom, quindi se mancano dettagli,assicuratevi di avere uno zoom appropriato.

La mappa in versione PC è visualizzabile con il software Basecamp di Garmin sulle piattaforme Windows o anche altri software su altre piattaforme purchè leggano il formato IMG. Per poterla visualizzare è necessario scompattarla (se scaricata da internet) e lanciare il batch install.bat per fare in modo che vengano scritte nel sistema le chiavi di registro e poi aprire il software Basecamp per poterla vedere.
Se invece è prodotta con questi script prelevare la cartella 'mappe' dalla directory 'finale' per poi andarla ad installare come descritto prima.


La mappa in versione android deve essere caricata nella directory del programma che la leggerà, oltre alla mappa bisognerà caricare la cartella del tema mapsforge nella directory dei temi.
Tramite l'app che leggerà la mappa bisognerà selezionare il tema bdtre-osm.


3. Dettagli tecnici
-------------------


3.1 Prerequisiti
----------------

Per creare la mappa occorre che nel sistema (UBUNTU) siano presenti:

-- gdal-bin (da installare nel sistema)

-- python-gdal (da installare nel sistema)

-- python-lxml (da installare nel sistema)

-- openjdk 11 (da installare nel sistema)

-- osmctools (da installare nel sistema)

-- osmium-tool (da installare nel sistema)

-- osmosis (aggiungere la stringa 'JAVACMD_OPTIONS=-Xmx8G' nel file'osmosis/bin/osmosis' se non è già stato inserito, inserire al posto di 8 un valore pari alla quantità della vostra RAM)

-- osm2ogr (inserire il percorso completo nel file "configurazione")

-- mkgmap (inserire il percorso completo nel file "configurazione")

-- splitter (inserire il percorso completo nel file "configurazione")

-- gmt (gmaptool per linux) (inserire il percorso completo nel file "configurazione")


3.2 Ottenimento dati BDTRE
--------------------------

La Regione Piemonte mette a disposizione i dati del BDTRE (Base Dati Territoriale di Riferimento degli Enti) per il riuso su base comunale, nominati secondo il proprio codice ISTAT, sia come WMS sia come dato cartografico.

I dati originali possono essere scaricati da questa pagina:

 http://www.geoportale.piemonte.it/geocatalogorp/?sezione=catalogo   (cercare per "geotopografico" .....)


L'interfaccia non è molto adatta per l'acquisizione di tutti i 11181 comuni, ma avendo bisogno dei dati, questa è la fonte ufficiale.
Per aiutare con il processo, una lista di tutti i comuni si trova all'interno della cartella "Scarico/comuni".

Nella cartella "Scarico/comuni" si trova un file txt riepilogativo per il download di tutti i comuni del Piemonte ed i relativi codici ISTAT. Per comodità i comuni sono anche stati divisi in piccoli file per provincia. 
Per agevolare il dowload sono stati creati questi file da dare in pasto a wget che scarica la regione completa o la singola provincia a seconda del file specificato.
Se per esigenze specifiche servono pochi comuni per una gestione locale, basta creare un file txt su misura e cambiare nello script "scaricabdtre.sh". Se vi serve una singola provincia specifica potete utilizzare quelli già presenti per le singole province. 

I dati BDTRE vengono aggiornati annualmente alla data del 31/12 di ogni anno e resi disponibili nel  mese di marzo/aprile dell'anno successivo.
Tutti i dati e i servizi della BDTRE pubblicati sono resi disponibili con licenza Creative Commons - BY 4.0, che consente di utilizzare i dati previa attribuzione.
Sul sito del geoportale della Regione Piemonte è presente un link alla licenza, seguendolo è possibile consultare il testo della licenza stessa.
All'interno di ogni singolo file zip, è allegato un estratto della licenza in formato pdf.


3.3 Ottenimento dati OSM
------------------------

I dati OSM (OpenStreetMap), sono visualizzabili graficamente sul sito internet www.openstreetmap.org. In questo modo però non sono da noi utilizzabili, in quanto abbiamo bisogno di lavorare con i dati vettoriali grezzi.

I dati grezzi vengono forniti da OSM sotto forma di estratti (nazionali, regionali, ecc) in formato OSM e con licenza ODbl.
Esistono molte vie e molti canali dove reperire i dati OSM, per quello che ci interessa per questo progetto li si può prendere qui:

http://geodati.fmach.it/gfoss_geodata/osm/output_osm_regioni/piemonte.osm.bz2

Gli estratti regionali vengono aggiornati settimanalmente il giovedì/venerdì.


3.4 Curve di livello
--------------------

Le curve di livello presenti nel BDTRE hanno un valore di equidistanza pari a 10 metri, sono curve molto precise e dettagliate che consente una buona analisi del territtorio.
Per un uso prettamente escursionistico ritengo possano essere eccessive, funzionalmente possono essere impiegate quelle a 20 metri.

Per poter usufruire delle curve a 20 metri bisogna far girare lo script "curve20.sh" che provvede a scaricare i file tif del DTM regionale, crea le curve a 20 metri e le divide su base comunale sostituendole a quelle originali con equidistanza a 10 metri.
Lo script "curve20a.sh" genera le curve a 20 metri, le taglia su base comunale e le sostituisce a quelle a 10 metri senza scaricare il DTM. Eseguire questo script solamente se è stato scaricato il DTM precedentemente e per ripristinare le curve a 20 metri.


4. Costruzione della mappa, uso  e sequenza degli scripts
---------------------------------------------------------

Prima di iniziare a fare girare gli script è bene sistemare i percorsi delle directori in cui si trovano i file scaricati ed i vari tool che concorrono al lavoro.
Le variabili vanno verificate/modificate nel file configurazione, in questo modo gli script vanno a richiamare le medesime senza doverle riscrivere o variare ogni volta che vengono lanciati gli script.

Gli script non sono pensati per avere un diverso albero delle directory, si possono modificare i nomi delle directory, ma non la loro posizione.


4.1 Sequenza di script comuni per la conversione e selezione dei dati
---------------------------------------------------------------------

scaricabdtre.sh
unzipbdtre.sh
curve20.sh (opzionale, serve solo a cambiare le curve 20 metri con le 10 metri se si vuole meno curve)
shp.sh (opzionale, serve ad unire i file in formato shp per poter vedere in qgis quali elementi sono presenti)
shpaosm.sh
uniscibdtre.sh


4.2 Sequenza di script per la creazione della mappa per Android
---------------------------------------------------------------

osmamap.sh

4.3 Sequenza di script per la creazione della mappa per Garmin
---------------------------------------------------------------

bdtre2img.sh
osm2img.sh
unisciimg.sh
zipgarmin.sh

