-- Premiere Partie Creation des Tables Et Insertions d'exemples dans ces Tables 
CREATE TABLE Clients(
	id_client INT AUTO_INCREMENT,
	nom VARCHAR(255) NOT NULL,
	prenom VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	telephone VARCHAR(255) NOT NULL,
	numero_carte_credit LONG NOT NULL,
	PRIMARY KEY(id_client)
);

CREATE TABLE Destinations(
	id_destination INT AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    prix DECIMAL(10,2) NOT NULL,
    image BLOB,
    PRIMARY KEY (id_destination)    
);

CREATE TABLE Voyages(
	id_voyage INT,
    id_destination INT,
    date_depart DATE,
    date_retour DATE,
    nb_places INT,
    prix DECIMAL(10,2),
    statut VARCHAR(255),
    PRIMARY KEY (id_voyage),
    FOREIGN KEY (id_destination) REFERENCES Destinations(id_destination)
);

CREATE TABLE Reservations(
 id_reservation INT PRIMARY KEY,
 id_client INT,
 id_voyage INT,
 date_reservation DATE,
 statut VARCHAR(255),
 FOREIGN KEY(id_client) REFERENCES  Clients(id_client),
 FOREIGN KEY (id_voyage) REFERENCES Voyages(id_voyage)
);

-- Insertion dans Clients :
INSERT INTO Clients (nom, prenom, email, telephone, numero_carte_credit) 
VALUES ('Gas', 'Romain', 'romain.gas@efrei.net', '1234567890', 1234567890123456),
       ('Nadaud', 'Rayan', 'rayan.nadaud@efrei.net', '9876543210', 9876543210987654),
       ('Boulouha', 'Amna', 'amna.boulouha@efrei.net', '5555555555', 5555555555555555);
      

-- Insertion dans Destinations : 
INSERT INTO Destinations (nom, description, prix, image) 
VALUES ('Paris', 'La ville lumière', 500.00, NULL),
       ('New York', 'La ville qui ne dort jamais', 700.00, NULL),
       ('Tokyo', 'La ville moderne et traditionnelle', 800.00, NULL),
       ('Rome', 'La ville éternelle', 600.00, NULL),
       ('Dubai', "La ville du luxe et de l'excentricité", 900.00, NULL);
       
-- Insertion dans Voyages : 
INSERT INTO Voyages (id_voyage, id_destination, date_depart, date_retour, nb_places, prix, statut) 
VALUES (1, 1, '2024-06-01', '2024-06-10', 50, 550.00, 'Disponible'),
       (2, 2, '2024-07-15', '2024-07-25', 40, 750.00, 'Disponible'),
       (3, 3, '2024-08-10', '2024-08-20', 60, 850.00, 'Disponible');
  
-- Insertion dans Reservations :
INSERT INTO Reservations (id_reservation, id_client, id_voyage, date_reservation, statut) 
VALUES (1, 1, 1, '2024-05-01', 'Confirmée'),
       (2, 2, 2, '2024-05-02', 'Confirmée'),
       (3, 3, 3, '2024-05-03', 'En attente');
     

-- Deuxième Partie Creation des Vues.

-- Vue Infos clients
CREATE VIEW Infos_clients AS
SELECT CONCAT(nom, ' ', prenom) AS nom_complet, email, telephone
FROM Clients;

-- Afficher la vue Infos clients
SELECT * FROM Infos_clients;

-- Creation de la Vue Destination avec prix 
CREATE VIEW Destinations_avec_prix AS
SELECT nom, description, prix FROM Destinations;

-- Afficher la Vue Destination avec prix
SELECT * FROM Destinations_avec_prix;

-- Creation de la Vue Voyages Disponibles
CREATE VIEW Voyages_disponibles AS
SELECT *
FROM Voyages
WHERE date_depart > CURDATE() AND nb_places > 0;

-- Afficher la vue Voyages Disponibles
SELECT * FROM Voyages_disponibles;

-- Creer la vue Details reservation
CREATE VIEW Details_reservations AS
SELECT r.id_reservation, CONCAT(c.nom, ' ', c.prenom) AS nom_client, c.email AS email_client, c.telephone AS telephone_client, 
       v.id_voyage, d.nom AS destination, v.date_depart, v.date_retour, v.nb_places, v.prix AS prix_voyage, r.date_reservation, r.statut
FROM Reservations r
JOIN Clients c ON r.id_client = c.id_client
JOIN Voyages v ON r.id_voyage = v.id_voyage
JOIN Destinations d ON v.id_destination = d.id_destination;

-- Afficher la vue Details Reservation

SELECT * from Details_reservations;

-- Creer la vue Prochains Voyages 
CREATE VIEW Prochains_voyages AS
SELECT CONCAT(c.nom, ' ', c.prenom) AS nom_client, v.id_voyage, d.nom AS destination, v.date_depart, v.date_retour, v.nb_places, v.prix
FROM Reservations r
JOIN Clients c ON r.id_client = c.id_client
JOIN Voyages v ON r.id_voyage = v.id_voyage
JOIN Destinations d ON v.id_destination = d.id_destination
WHERE v.date_depart BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- Afficher les Prochains voyages 
SELECT * From Prochains_voyages;

-- Vue Destinations Populaires : 
CREATE VIEW Destinations_populaires AS
SELECT d.nom AS destination, COUNT(r.id_reservation) AS nombre_reservations
FROM Reservations r
JOIN Voyages v ON r.id_voyage = v.id_voyage
JOIN Destinations d ON v.id_destination = d.id_destination
GROUP BY d.nom
ORDER BY COUNT(r.id_reservation) DESC;

-- Afficher la Vue Destination Populaire
SELECt * From Destinations_populaires;

-- Creation Vue Voyage Populaire:
CREATE VIEW Voyages_populaires AS
SELECT v.id_voyage, d.nom AS destination, v.date_depart, v.date_retour, v.nb_places, v.prix, 
       ((v.nb_places - COUNT(r.id_reservation)) / v.nb_places) * 100 AS pourcentage_places_restantes
FROM Voyages v
JOIN Destinations d ON v.id_destination = d.id_destination
LEFT JOIN Reservations r ON v.id_voyage = r.id_voyage
GROUP BY v.id_voyage
HAVING pourcentage_places_restantes < 10;

-- Afficher les Voyages Populaires : 
SELECT * FROM Voyages_populaires;

-- Creation Vue Voyages avec reservations : 
CREATE VIEW Voyages_avec_réservations AS
SELECT v.id_voyage, d.nom AS destination, v.date_depart, v.date_retour, v.nb_places, v.prix, COUNT(r.id_reservation) AS nombre_reservations
FROM Voyages v
JOIN Destinations d ON v.id_destination = d.id_destination
LEFT JOIN Reservations r ON v.id_voyage = r.id_voyage
GROUP BY v.id_voyage;

-- Afficher Voyages Avec reservation :
SELECT * FROM Voyages_avec_réservations;

-- Creation de l'index prix sur la table destination 
CREATE INDEX idx_prix ON Destinations (prix);

-- Creation de l'index date_depart et date_retour sur la table voyage: 
CREATE INDEX idx_date_voyage ON Voyages (date_depart, date_retour);

-- Creation d'un index sur une VUE : 
CREATE INDEX idx_nom_complet ON Infos_clients (nom_complet);

-- Impossible car on creer un index sur une vue et non sur une table


-- Creation d'un "CLIENT" pour simuler un cas
CREATE USER 'client'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT ON tp2_bdd_voyage.Destinations_avec_prix TO 'client'@'localhost';
GRANT SELECT ON tp2_bdd_voyage.Voyages_disponibles TO 'client'@'localhost';

-- Creation de l'utilisateur agent_de_voyage 
CREATE USER 'agent_de_voyage'@'localhost' IDENTIFIED BY '12345';
-- Accorder les privilèges sur les tables
GRANT SELECT, INSERT, UPDATE ON tp2_bdd_voyages.Clients TO 'agent_de_voyage'@'localhost';
GRANT SELECT, INSERT, UPDATE ON tp2_bdd_voyages.Destinations TO 'agent_de_voyage'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tp2_bdd_voyages.Voyages TO 'agent_de_voyage'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON tp2_bdd_voyages.Reservations TO 'agent_de_voyage'@'localhost';


-- Accorder les privilèges sur les vues
GRANT SELECT ON tp2_bdd_voyages.Voyages_avec_réservations TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Voyages_populaires TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Destinations_populaires TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Prochains_voyages TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Details_reservations TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Voyages_disponibles TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Destinations_avec_prix TO 'agent_de_voyage'@'localhost';
GRANT SELECT ON tp2_bdd_voyages.Infos_clients TO 'agent_de_voyage'@'localhost';
