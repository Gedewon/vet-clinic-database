SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-30';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE NOT name='Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;


BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT BEFORE2022;
UPDATE animals SET weight_kg = (weight_kg*-1);
ROLLBACK TO BEFORE2022;
UPDATE animals SET weight_kg = (weight_kg*-1) WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*)
FROM animals;

SELECT COUNT(*)
FROM animals
WHERE escape_attempts =0;

SELECT AVG(weight_kg)
FROM animals;

SELECT neutered,COUNT(escape_attempts)
FROM animals
GROUP BY neutered;

SELECT species,MIN(weight_kg),MAX(weight_kg)
FROM animals
GROUP BY species;

SELECT species,AVG(escape_attempts)
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

SELECT name
FROM animals
INNER JOIN owners
ON animals.owners_id = owners.id
WHERE full_name = 'Melody Pond';

SELECT animals.name
FROM animals
JOIN species
ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT owners.full_name,animals.name as animal_name
FROM owners
LEFT JOIN animals
ON owners.id = animals.owners_id;

SELECT species.name,COUNT(*)
FROM animals
LEFT JOIN species
ON animals.species_id = species.id
GROUP BY species.name;

SELECT animals.name
FROM animals
LEFT JOIN species
ON animals.species_id = species.id
LEFT JOIN owners
ON owners_id = owners.id
WHERE species.name = 'Digimon' AND full_name = 'Jennifer Orwell';

SELECT animals.name
FROM animals
LEFT JOIN owners
ON animals.owners_id = owners.id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

SELECT full_name, COUNT(*)
FROM animals
LEFT JOIN owners
ON owners_id = owners.id
GROUP BY full_name
ORDER BY COUNT(*) DESC LIMIT 1;


SELECT animals.name
FROM animals
LEFT JOIN visits
ON visits.animals_id = animals.id
LEFT JOIN vets
ON visits.vets_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date DESC LIMIT 1;

SELECT COUNT(animals.name)
FROM animals
LEFT JOIN visits
ON visits.animals_id = animals.id
LEFT JOIN vets
ON visits.vets_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

SELECT vets.name as vets_name, species.name  as species_name
FROM vets
FULL JOIN specializations
ON specializations.vets_id = vets.id
FULL JOIN species
ON species.id = specializations.species_id;

SELECT animals.name
FROM animals
JOIN visits
ON visits.animals_id = animals.id
JOIN vets
ON visits.vets_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date BETWEEN '2020-04-01' AND '2020-08-30';

SELECT animals.name, COUNT(animals.name)
FROM animals
JOIN visits
ON visits.animals_id = animals.id
GROUP BY animals.name
ORDER BY COUNT(animals.name) DESC LIMIT 1;

SELECT animals.name
FROM animals
JOIN visits
ON visits.animals_id = animals.id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date LIMIT 1;

SELECT animals.*, vets.*, visits.date
FROM animals
JOIN visits
ON visits.animals_id = animals.id
JOIN vets
ON vets.id = visits.vets_id
ORDER BY visits.date DESC LIMIT 1;

SELECT COUNT (*)
FROM visits
FULL JOIN animals
ON animals.id = visits.animals_id
FULL JOIN vets
ON vets.id = visits.vets_id
FULL JOIN specializations
ON specializations.vets_id = vets.id
WHERE specializations.species_id is NULL;

SELECT species.name, COUNT(*)
FROM visits
JOIN animals
ON animals.id = visits.animals_id
JOIN species
ON species.id = animals.species_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(*) DESC LIMIT 1;


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animals_id, vets_id, date) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
