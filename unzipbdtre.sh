#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip