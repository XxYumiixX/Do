-- Réservé Gc7

DROP DATABASE IF EXISTS `aaxu`;
CREATE DATABASE `aaxu`
  DEFAULT CHARACTER SET `latin1`
  DEFAULT COLLATE `latin1_general_ci`;

USE aaxu;

-- #################################################################################################
--
--                                       CRÉATION TABLE XU
--
-- #################################################################################################
DROP TABLE IF EXISTS xu;

CREATE TABLE `xu` (
  `id`      INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
  `pseudo`  VARCHAR(255)        NOT NULL
  COLLATE 'latin1_general_ci',
  `lv`      TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `typ`     CHAR(1)             NOT NULL DEFAULT 'A' COLLATE 'latin1_general_ci',
  `lva`     TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `lvp`     TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `parrain` VARCHAR(255)        NULL     DEFAULT NULL COLLATE 'latin1_general_ci',
  `parr`    INT(11) UNSIGNED    NULL     DEFAULT NULL,
  `bg`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  `bd`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  `pf`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `lv` (`lv`),
  INDEX `typ` (`typ`),
  INDEX `bg` (`bg`),
  INDEX `bd` (`bd`),
  INDEX `pf` (`pf`)
)
  COLLATE = 'latin1_general_ci'
  ENGINE = InnoDB
  AUTO_INCREMENT = 1
    SELECT
      uid                     AS id,
      uname                   AS pseudo,
      lv,
      typ,
      lva,
      lvp,
      parr                    AS parrain,
      (SELECT uid
       FROM www_boos2013.xoops_users
       WHERE uname = xu.parr) AS parr,
      '0'                     AS bg,
      '0'                     AS bd,
      '0'                     AS pf
    FROM www_boos2013.xoops_users xu;

-- ALTER TABLE aaxu.xu ADD PRIMARY KEY (id);

SELECT *
FROM xu;

DROP TABLE IF EXISTS aaxu.xut;
-- #################################################################################################
--
--             CRÉATION TABLE xut pour test d'insertion (Départ avec Aadminli uniquement)
--
-- #################################################################################################
CREATE TABLE `aaxu`.`xut` (
  `id`      INT(11) UNSIGNED    NOT NULL AUTO_INCREMENT,
  `pseudo`  VARCHAR(255)        NOT NULL UNIQUE
  COLLATE 'latin1_general_ci',
  `lv`      TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `typ`     CHAR(1)             NOT NULL DEFAULT 'A' COLLATE 'latin1_general_ci',
  `lva`     TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `lvp`     TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  `parrain` VARCHAR(255)        NULL     DEFAULT NULL COLLATE 'latin1_general_ci',
  `parr`    INT(11) UNSIGNED    NULL     DEFAULT NULL,
  `bg`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  `bd`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  `pf`      INT(11) UNSIGNED    NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `lv` (`lv`),
  INDEX `typ` (`typ`),
  INDEX `bg` (`bg`),
  INDEX `bd` (`bd`),
  INDEX `pf` (`pf`)
)
  COLLATE 'latin1_general_ci'
  ENGINE = InnoDB
  ROW_FORMAT = DYNAMIC
  AUTO_INCREMENT = 1;

-- Insertion (par copie) de Aadminli
INSERT INTO `aaxu`.`xut` (`id`, `pseudo`, `lv`, `typ`, `lva`, `lvp`, `parrain`, `parr`, `bg`, `bd`, `pf`)
  SELECT
    `id`,
    `pseudo`,
    `lv`,
    `typ`,
    `lva`,
    `lvp`,
    `parrain`,
    `parr`,
    `bg`,
    `bd`,
    `pf`
  FROM `xu`
  WHERE id < 2;
-- Suppr Kl
DELETE FROM `aaxu`.`xu`
WHERE `id` = 15;
-- Initialisation Aadminli : Parrain et parr null, bornes G et D (Et pf)
UPDATE aaxu.xut
SET parrain = NULL, parr = NULL, bg = 1, bd = 2, pf = 0;

-- Re-initialise Aadminli pour départ tests
TRUNCATE aaxu.xut;
INSERT INTO `aaxu`.`xut` (`id`, `pseudo`, `lv`, `typ`, `lva`, `lvp`, `parrain`, `parr`, `bg`, `bd`, `pf`)
VALUES (1, 'Aadminli', 1, 'P', 0, 0, NULL, NULL, 1, 2, 0);
SELECT *
FROM xut;

-- #################################################################################################
--
--            PROCÉDURE pour INSERTION et calcul des bornes et profondeur (pf)
--
-- #################################################################################################
-- ToDoLi ajout lock Table qd Opé + activer transaction (Cf. arbre/exemple_proc.sql)
-- ToDoLi Cf. arbre/exemple_proc.sql pour proc avec boucle


DROP PROCEDURE IF EXISTS insertXu;
DELIMITER |
CREATE DEFINER =`root`@`localhost` PROCEDURE `insertXu`(
  IN `pseudoXu` VARCHAR(255),
  IN `idRef`    INT
)
  BEGIN
    -- START TRANSACTION;

    DECLARE pseudoRef VARCHAR(255);
    DECLARE bgRef, bdRef, pfRef INT(11);

    -- Réc valeur du parr
    SELECT
      pseudo,
      bg,
      bd,
      pf
    INTO pseudoRef, bgRef, bdRef, pfRef
    FROM xut
    WHERE id = idRef;

    -- SET @pseudoParr = pseudoRef;

    UPDATE xut
    SET bd = bd + 2
    WHERE bd >= bdRef;

    UPDATE xut
    SET bg = bg + 2
    WHERE bg >= bdRef;

    INSERT INTO xut (pseudo, parrain, parr, bg, bd, pf)
    VALUES (pseudoXu, pseudoRef, idRef, bdRef, (bdRef + 1), (pfRef + 1));

    -- COMMIT;
  END |
DELIMITER ;


CALL insertXu('GrCOTE7', 1);
SELECT *
FROM xut;

CALL insertXu('Doro', 2);
CALL insertXu('Jade', 3);
SELECT *
FROM xut;


CALL insertXu('Mimi', 3);
CALL insertXu('Jeny', 4);
CALL insertXu('Micky', 6);


SELECT concat(id, repeat(' ', (pf + .25) * 4), pseudo, ' (', bg, '-', bd, ')') 'XUs'
FROM aaxu.xut
ORDER BY bg;


SELECT
  concat(id, repeat(' ', (pf + .25) * 4), pseudo, ' (', bg, '-', bd, ')') 'Membre',
  lv,
  typ
FROM aaxu.xut
WHERE bg >= 1
      AND bd <= 120
ORDER BY bg;


SELECT
  pseudo AS pseudoRef,
  bg     AS bgRef,
  bd     AS bdRef,
  pf     AS pfRef
FROM xut
WHERE id = 1;


USE aazt;

SELECT *
FROM b;

DROP PROCEDURE IF EXISTS boucle_b1;
CREATE PROCEDURE boucle_b1()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id, v_stop INT;
    DECLARE v_pseudo, v_parr VARCHAR(255);


    DECLARE b_cursor CURSOR FOR
      SELECT
        uid,
        uname,
        parr
      FROM b1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Var pour stopper la boucle à la volée
    SET v_stop = 0;
    DROP TEMPORARY TABLE IF EXISTS t_b;
    CREATE TEMPORARY TABLE t_b (
      id     INT,
      pseudo VARCHAR(255),
      parr   VARCHAR(255)
    );

    OPEN b_cursor;

    b_loop: LOOP
      FETCH b_cursor
      INTO v_id, v_pseudo, v_parr;

      IF done OR v_stop
      THEN
        LEAVE b_loop;
      END IF;

      SET v_stop = v_stop + 1;

      INSERT INTO t_b (id, pseudo, parr) VALUES
        (v_id,
         v_pseudo,
         v_parr);
    END LOOP;

    CLOSE b_cursor;

    SELECT *
    FROM t_b;

  END;

CALL test_boucle_b();

USE aazt;

DROP PROCEDURE IF EXISTS boucle_b1;
CREATE PROCEDURE boucle_b1()
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id, v_stop, v_parr INT;
    DECLARE v_pseudo, v_parrain VARCHAR(255);

    DECLARE b_cursor CURSOR FOR
      SELECT
        uid,
        uname,
        parr
      FROM b1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Var pour stopper la boucle à la volée
    SET v_stop = 0;
    SET v_parr = 0;

    OPEN b_cursor;

    b_loop: LOOP
      FETCH b_cursor
      INTO v_id, v_pseudo, v_parrain;

      SELECT
        v_id,
        v_pseudo,
        v_parrain;

      SELECT id
      INTO v_parr
      FROM b2
      WHERE PSEUDO = v_parrain;

      SET v_parrain = concat(v_parrain, ' ', v_parr);

      IF done OR v_stop = 111 OR v_parr <> 0
      THEN
        LEAVE b_loop;
      END IF;

      SET v_stop = v_stop + 1;

      IF v_parr <> 0
      THEN
        INSERT INTO b2 (pseudo, parr, uid, parrain) VALUES
          (
            v_pseudo,
            v_parr,
            v_id,
            v_parrain
          );
      END IF;
    END LOOP;

    CLOSE b_cursor;

    SELECT *
    FROM b1;

  END;

CALL boucle_b1();
SELECT *
FROM b2;

