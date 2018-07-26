# NightmareJS - headless server with docker

## Auteur

* David PEREIRA

## Instructions

#### 1. Cloner le projet

>git clone https://github.com/DeRosario/nightmarejs-headless.git

#### 2.  Lancer le script d'installation

>sh start\_nightmare\_container.sh

#### 3. Lancer le script javascript dans le docker

>docker exec -ti nightmaredocker sh

Cette commande permet de rentrer dans le container `nightmaredocker` et d'y éxécuter des commandes dans le terminal.

>DEBUG=nightmare xvfb-run --server-args="-screen 0 1024x768x24" node demonstration.js

Cette commande permet, grâce à Xvfb (X virtual framebuffer), de lancer des opérations graphique dans la mémoire virtuelle sans sortie d'écran. Puis de lancer le script js `demonstration.js`

## Screenshots

![Final Output](/screenshots/final-output.jpg?raw=true)
