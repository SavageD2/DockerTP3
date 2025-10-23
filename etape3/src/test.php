<?php
// Connexion (host = nom du service du conteneur MariaDB : "data" ou "db" selon ton compose)
$mysqli = new mysqli('data', 'monuser', 'password', 'mabase', 3306);
if ($mysqli->connect_errno) {
    http_response_code(500);
    printf("Connect failed: (%d) %s\n", $mysqli->connect_errno, $mysqli->connect_error);
    exit;
}

// 1) ECRITURE : insérer compteur = MAX(compteur)+1 (ou 1 si table vide)
$insertSql = "INSERT INTO matable (compteur)
              SELECT COALESCE(MAX(compteur), 0) + 1 FROM matable";
if (!$mysqli->query($insertSql)) {
    printf("Insert error: (%d) %s\n", $mysqli->errno, $mysqli->error);
    $mysqli->close();
    exit;
}
printf("Insert OK — affected_rows: %d<br />\n", $mysqli->affected_rows);

// 2) LECTURE : combien de lignes au total ?
$countSql = "SELECT COUNT(*) AS total FROM matable";
if (!$result = $mysqli->query($countSql)) {
    printf("Select error: (%d) %s\n", $mysqli->errno, $mysqli->error);
    $mysqli->close();
    exit;
}
$row = $result->fetch_assoc();
printf("Total rows in matable: %d<br />\n", (int)$row['total']);
$result->close();

// (optionnel) Lire la dernière ligne insérée
$lastSql = "SELECT compteur FROM matable ORDER BY compteur DESC LIMIT 1";
if ($resLast = $mysqli->query($lastSql)) {
    $last = $resLast->fetch_assoc();
    printf("Last compteur value: %d<br />\n", (int)$last['compteur']);
    $resLast->close();
}

$mysqli->close();
