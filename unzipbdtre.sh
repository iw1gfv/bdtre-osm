#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#verifica che sia presente la cacartellla con i file scaricati del BDTRE
if [[ ! -d $bdtrez ]]
then
  echo "Non esiste la cartella con i file scaricati del BDTRE"
  exit 1
fi

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip
