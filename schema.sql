CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id              INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    name            VARCHAR(100),
    date_of_birth   DATE,
    escape_attempts INT,
    neutered        BOOLEAN,
    weight_kg       DECIMAL,

    PRIMARY KEY(id)
);

ALTER TABLE animals ADD species varchar(100);


CREATE TABLE owners (
   id         INT NOT NULL GENERATED ALWAYS AS IDENTITY,
   full_name  VARCHAR(100),
   age        INT,

   PRIMARY KEY(id)
);

CREATE TABLE species (
  id          INT NOT NULL GENERATED ALWAYS AS IDENTITY,
  name        VARCHAR(100),

  PRIMARY KEY(id)
);

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT,
ADD CONSTRAINT fk_species_id
FOREIGN KEY (species_id)
REFERENCES species(id)
ON DELETE CASCADE;

ALTER TABLE animals ADD COLUMN owners_id INT,
ADD CONSTRAINT fk_owners_id
FOREIGN KEY (owners_id)
REFERENCES owners(id)
ON DELETE CASCADE;
