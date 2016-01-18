#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#verifica che sia presente la cartellla con i file scaricati del BDTRE
if [[ ! -d $sbdtrez ]]
then
  echo "Non esiste la cartella $sbdtrez, crea la cartella e metti i file all'interno oppure controlla di aver seguito il percorso giusto"
  exit 1
fi

#rimuove la cartella dei file scompattati
rm $sbdtre

#rcrea la cartella dei file scompattati
mkdir $sbdtre

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip
