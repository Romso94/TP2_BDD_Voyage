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
VALUES ('Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 1234567890123456),
       ('Smith', 'Emily', 'emily.smith@example.com', '9876543210', 9876543210987654),
       ('Garcia', 'Maria', 'maria.garcia@example.com', '5555555555', 5555555555555555),
       ('Chen', 'Wei', 'wei.chen@example.com', '6666666666', 6666666666666666),
       ('Kim', 'Ji-hyun', 'ji-hyun.kim@example.com', '4444444444', 4444444444444444);

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
       (3, 3, '2024-08-10', '2024-08-20', 60, 850.00, 'Disponible'),
       (4, 4, '2024-09-05', '2024-09-15', 45, 650.00, 'Disponible'),
       (5, 5, '2024-10-20', '2024-10-30', 55, 950.00, 'Disponible');

INSERT INTO Reservations (id_reservation, id_client, id_voyage, date_reservation, statut) 
VALUES (1, 1, 1, '2024-05-01', 'Confirmée'),
       (2, 2, 2, '2024-05-02', 'Confirmée'),
       (3, 3, 3, '2024-05-03', 'En attente'),
       (4, 4, 4, '2024-05-04', 'En attente'),
       (5, 5, 5, '2024-05-05', 'Confirmée');

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
JOIN Voyages v ON r.id_voyagetrip = v.id_voyage
JOIN Destinations d ON v.id_destination = d.id_destination;

-- Afficher la vue Details Reservation

SELECT * from Details_reservations;


