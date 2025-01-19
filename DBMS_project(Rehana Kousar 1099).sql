CREATE TABLE university_professors(
	firstname VARCHAR(30),
	lastname VARCHAR(30),
	university VARCHAR(30),
	university_shortname VARCHAR(10),
	university_city VARCHAR(30),
	function VARCHAR(256),
	organization VARCHAR(256),
	organization_sector VARCHAR(256)
);
SELECT* FROM university_professors;


CREATE TABLE universities (
    id SERIAL PRIMARY KEY,          -- Unique ID for each university
    university_name TEXT NOT NULL,  -- Full name of the university
    university_shortname TEXT NOT NULL UNIQUE, -- Abbreviation/short name
    university_city TEXT NOT NULL   -- City where the university is located
);
INSERT INTO universities (university_name, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professors;

SELECT* FROM universities;

CREATE TABLE professors (
    id  SERIAL PRIMARY KEY,          -- Unique ID for each professor
    firstname TEXT NOT NULL,        -- First name of the professor
    lastname TEXT NOT NULL,         -- Last name of the professor
    university_id INT NOT NULL,     -- Foreign key referencing universities
    FOREIGN KEY (university_id)
        REFERENCES universities (id)
        ON DELETE CASCADE           -- Delete professor if university is deleted
);
INSERT INTO professors (firstname, lastname, university_id)
SELECT DISTINCT 
    up.firstname,
    up.lastname,
    u.id AS university_id
FROM university_professors up
JOIN universities u ON up.university_shortname = u.university_shortname;

SELECT* FROM professors;


CREATE TABLE organizations (
    organization_sector TEXT NOT NULL -- Sector to which the organization belongs
);
ALTER TABLE organizations ADD COLUMN organization TEXT UNIQUE;




SELECT* FROM organizations;


INSERT INTO organizations
SELECT DISTINCT organization,organization_sector
FROM university_professors;

SELECT * FROM organizations;


CREATE TABLE is_affiliated_with (
    professor_id INT NOT NULL,      -- Foreign key referencing professors
    organization_id INT NOT NULL,   -- Foreign key referencing organizations
    function TEXT,                  -- Function or role of the professor in the organization
    FOREIGN KEY (professor_id)
        REFERENCES professors (id)
        ON DELETE CASCADE       -- Delete affiliation if professor is deleted
);
ALTER TABLE is_affiliated_with RENAME COLUMN organization_id TO organization;
ALTER TABLE is_affiliated_with ALTER COLUMN organization TYPE text;



INSERT INTO is_affiliated_with 
SELECT DISTINCT 
    p.id AS professor_id,
    u.organization AS organization,
    u.function
FROM university_professors AS u
LEFT JOIN professors AS p
USING(firstname,lastname);

SELECT* FROM is_affiliated_with;


