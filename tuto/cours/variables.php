<h3>Mon cours sur les variables</h3>

<?php

// Exemple avec formulaire
// include './tuto/initiation/tableMultiplication.php';


 $a = [
    'Soleil',
    'lune',
    'mars'
];

for ($i=0; $i < 3; $i++) { 
  
  echo $a[$i].'<br>';
  
}



echo '<hr>';



$a[1]="Jupiter";



echo '<hr>';




for ($i=0; $i < 10; $i++) { 
 echo "$i ";
}



echo '<hr>';


for ($i=0; $i < 3; $i++) { 
  
  echo $a[$i].'<br>';
  
}






/* Déclaration de variables de types différents
           
           Déclaration de variables PHP

Correct	        Incorrect	      Explications
           
           

$variable	      variable	      Une variable doit commencer par $
$Variable1	    $Variable 1	    Les espaces sont interdits
$variable_suite	$variable-suite	Le tiret est interdit
$_variable	    $-variable	    Le tiret est interdit
$variable2	    $2variable	    Il ne peut y avoir de chiffre après le $

*/

 /* $prenom = 'Hugo';  // Type string (chaine de caractères)
  $nom = "Hamon";    // Type string (chaine de caractères)
  $age = 19;    // Type entier
  $estEtudiant = true;  // Type booléen
  $cours = array('physique','chimie','informatique','philosophie'); // Type tableau
  $unEtudiant = new Etudiant (); // Objet de type Etudiant
*/
/* Pour les tableaux, on recontre le plus souvent cette notation :
$t = [item1, item2];
Exemple suit...
*/
