#!/bin/sh

printf "
====================================================================
||                                                                ||
|| Ce script permet de créer l'image docker de la partie          ||
|| \"scripting nightmarejs\" de SmartVM si non existante.           ||
||                                                                ||
||                                                                ||
|| Etapes :                                                       ||
||   - Création d'une image contenant tous les modules            ||
||     nécessaire au fonctionnement de nightmare.JS dans un       ||
||     conteneur docker d'un serveur headless                     ||
||                                                                ||
||   - Lancement d'un conteneur à partir de cette précédente      ||
||     image                                                      ||
||                                                                ||
||                                                                ||
====================================================================\n\n"

#
# Colors for output
#
RED='\033[1;31m'
GRN='\033[1;32m'
RST='\033[0m'

GETUSERSPATH=/var/nightmarejs-headless/scripts/get_users.js
DEMONSTRATIONPATH=/var/nightmarejs-headless/scripts/demonstration.js
#
# Create the base image if doesn't exist
#
BUILD=1
if [ $(docker images -q docker/nightmare-scripting) ]; then
  printf "\n ${GRN}[*]${RST} L'image de base \"docker/nightmare-scripting\" existe déjà. Voulez-vous la mettre à jour (prend jusqu'à 5 minutes) ? "
  while true; do
  read -p "[O/N] " answer
    case ${answer} in
      y|Y|o|O ) BUILD=1; break;;
      n|N ) BUILD=0; break;;
      * ) echo "Réponse incorrecte.";;
    esac
  done
fi

if [ $BUILD -eq 1 ]; then
  printf "\n ${GRN}[*]${RST} Création de l'image de base \"docker/nightmare-scripting\"\n"
  docker build -t docker/nightmare-scripting nightmare-headless-image
  if [ $? -ne 0 ]; then
    printf " ${RED}[*]${RST}-> Impossible de créer l'image.\n"
    exit -1
  fi
fi

#
# Start the containers
#
printf "\n ${GRN}[*]${RST} Arrêt et suppression du conteneur \"nightmaredocker\" existant... "
docker stop nightmaredocker ; docker rm -f nightmaredocker

printf " ${GRN}[*]${RST}-> Lancement du nightmaredocker.\n"
docker run -td \
  --name nightmaredocker \
  --restart unless-stopped \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume ${GETUSERSPATH}:/get_users.js \
  --volume ${DEMONSTRATIONPATH}:/demonstration.js \
  docker/nightmare-scripting sh

  if [ $? -ne 0 ]; then
    printf " ${RED}[*]${RST}-> Impossible de lancer le conteneur \"nightmaredocker\".\n"
  fi

docker exec -t nightmaredocker sh -c "
  npm install;
  exit;
"
