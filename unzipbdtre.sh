#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#verifica che sia presente la cartella con i file scaricati del BDTRE
if [[ ! -d $sbdtrez ]]
then
  echo "Non esiste la cartella $sbdtrez, fai girare lo script scaricabdtre.sh e scaricadtm.sh prima di questo"
  exit 1
fi

#rimuove la cartella dei file scompattati
rm -r $sbdtre

#rcrea la cartella dei file scompattati
mkdir $sbdtre

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip
