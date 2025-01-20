-- 1. new table certificates
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    person_id INT,
    CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES person(id)
);

-- 2. new person/row to person table (random name, not my name)
INSERT INTO person (name, age) VALUES ('John Doe', 30);

-- 3. new row to certificates table, attach scrum to john doe
INSERT INTO certificates (name, person_id)
VALUES ('Scrum', (SELECT id FROM person WHERE name = 'John Doe'));

-- 4. sdd scrum and azure to others in the table
INSERT INTO certificates (name, person_id)
VALUES
    ('Scrum', (SELECT id FROM person WHERE name = 'Jack')),
    ('Azure', (SELECT id FROM person WHERE name = 'Alice')),
    ('Scrum', (SELECT id FROM person WHERE name = 'Bob')),
    ('Azure', (SELECT id FROM person WHERE name = 'Charlie'));

-- 5. query all scrum holders
SELECT p.*
FROM person p
JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Scrum';

-- 6. query all azure holders
SELECT p.*
FROM person p
JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Azure';

select * from person
