<?php

include '../class/vehicule.php';
include '../class/voiture.php';

// Instanciation de l'objet : appel implicite à la méthode _construct()
$monVehicule = new Voiture('Renault');
$monVehicule->demarrer();
$monVehicule->reparer();

// Je remplis mon réservoir de 50 L d'essence
$monVehicule->setVolumeCarburant(50);

echo 'G '.$monVehicule->getVolumeCarburant().' litres de carburant';