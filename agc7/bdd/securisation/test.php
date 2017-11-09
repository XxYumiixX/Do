<?php

namespace GC7;

?>
<div class="jumbotron" xmlns="http://www.w3.org/1999/html">

  <h3 class="meaDo pb10">Exo final (6)</h3>

  <p class="lead"><a
      href="http://exercices.openclassrooms.com/assessment/223?login=441267&tk=31e3340fac83f036e28bc0016e777dc0&sbd=2016-02-01&sbdtk=fa78d6dd3126b956265a25af9b322d55"
      target="_blank">Mission</a></p>

  <p class="lead">(8/11/2017 - Env. 5 jours pour corr)</p>

</div>


<div class="maingc7">

  <p class="jumbotron lead pt10">1/ Page Accueil: Nb de commentaires (Stocké et automatiquement mise
    à jour)</p>


  <p class="lead">=> Création procédure perso pour savoir si une colonne existe</p>
  <?php

  $pdo = pdo( 'ocr2' );


  $sql = "drop procedure if exists columnExists;
-- DELIMITER |
CREATE PROCEDURE columnExists (
		in theColumn varchar(255),
		in theTable varchar(255),
		out p_exists int
)
BEGIN
	SELECT count(*) into p_exists from information_schema.columns
	where table_name =theTable and column_name=theColumn;
END;
-- END|";
  affLign( $sql );
  $pdo->query( $sql );


  $sql = "call columnExists('nb_commentaires', 'article', @columnExists);";
  affLign( $sql );
  $pdo->query( $sql );

  $sql = "select if(
  @columnExists,'<p class=\"fdBleuDo\">La colonne existe</p>',
  '<p class=\"fdRougeDo\">La colonne n\'existe pas</p>'
) as columnExists";
  affLign( "select if(
  @columnExists,'La colonne existe',  -- En bleu
  'La colonne n\'existe pas'          -- En rouge
) as columnExists" );

  $req( $sql, $pdo, 0 );

  // Effacement
  $sql = "ALTER TABLE `article`
DROP COLUMN `nb_commentaires`;";
  affLign( $sql );
  //    $pdo->query( $sql );


  // Ajout colonne
  $sql = "select if (@columnExists, 'Rien à faire',
  'ALTER TABLE `article`
ADD `nb_commentaires` INT(11) UNSIGNED NULL AFTER `date_publication`';
);";
  affLign( $sql );
  //    $pdo->query( $sql, $pdo );
  $req( $sql, $pdo );

  ?>


  <h3>Recherche solution pour tester présence d'une colonne</h3>
  <?php

  //  $pod = pdo();

  //  $sql = "show columns from article";
  $sql = "SELECT column_name, column_type from information_schema.columns
where table_schema='ocr2' and table_name='article' and column_name like '%comment%'";
  $req( $sql, $pdo );
  // ALTER TABLE `article`
  //	DROP COLUMN `nb_commentaires`;
  /*
  ?>
  <h3>Procédure d'ajout de la colonne directement</h3>

    <?php


    $sql = "SET @query =
  (SELECT
    IF(

       (
         SELECT COUNT(1)
         FROM INFORMATION_SCHEMA.COLUMNS

         WHERE
          TABLE_SCHEMA=database()
          AND TABLE_NAME = 'article'
          AND COLUMN_NAME = 'nb_commentaires'
       ) = 0,

       CONCAT(
           'ALTER TABLE article ADD COLUMN nb_commentaires varchar(255)'
             ),

       'SELECT \'ALREADY EXISTS\''
      )
    );";
    affLign( $sql );
    $pdo->query( $sql );

    $sql = "SELECT @query";
    $req( $sql, $pdo );

    $sql = "PREPARE st FROM @query;";
    affLign( $sql );
    $pdo->query( $sql );

    $sql = "EXECUTE st;";
    $req( $sql, $pdo );

  */
  //  $req($sql, $pdo);


  echo str_repeat( '<br>', 28 ); // 28


  echo str_repeat( '<br>', 28 ); // 28

  ?>
  <p class="lead">=> Ajout d'une colonne dans article, liée à un trigger</p>
  <?php

  $pdo = pdo( 'ocr2' );

  $sql = "ALTER TABLE `article`
ADD COLUMN `nb_commentaires` INT(11) UNSIGNED NULL
    AFTER `date_publication`;";
  affLign( $sql );
  //  $pdo->query( $sql );
  //  $req( $sql, $pdo );

  ?>

  <p class="jumbotron lead pt10">2/ Affichage Article: Un résumé doit apparaître (Si absent, les 150
    premiers caractères du contenu)</p>
  <?php

  $pdo = pdo( 'ocr2' );

  $sql = "select * from article limit 3";
  // affLign( $sql );
  // $pdo->query( $sql );
  //  $req( $sql, $pdo );

  ?>


  <p class="jumbotron lead pt10">3/ Mise en place de stats stockées dont la maj se fera à la demande
    :
  <ul>
    <li>Le nombre d’articles écrits,</li>
    <li>La date du dernier article,</li>
    <li>Le nombre de commentaires écrits</li>
    <li>Et la date du dernier commentaire.</li>
  </ul>
  </p>


  <!--
  // $pdo = pdo( 'ocr2' );

  // $sql = 'select * from article limit 3';

  //  affLign( $sql );
  // $pdo->query( $sql );
  //  $req( $sql, $pdo );
-->
     
  <?php
  echo str_repeat( '<br>', 28 ); // 28
  ?>
</div>
