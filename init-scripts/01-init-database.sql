-- ============================================================================
-- DATA1500 - Oppgavesett 1.5: Databasemodellering og implementasjon
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL -- Should be foreign key based on a role table
)

CREATE TABLE IF NOT EXISTS classrooms (
    classroom_id SERIAL PRIMARY KEY,
    classroom_owner_id INT NOT NULL,
    classroom_name VARCHAR(50) NOT NULL,
    classroom_code VARCHAR(50) NOT NULL,

    CONSTRAINT fk_user_id
        FOREIGN KEY (classroom_owner_id)
        REFERENCES users(user_id)
)

CREATE TABLE IF NOT EXISTS groups (
    access_key_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    classroom_id INT NOT NULL,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_classroom_id
        FOREIGN KEY (classroom_id)
        REFERENCES classrooms(classroom_id)
)

CREATE TABLE IF NOT EXISTS messages (
    message_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    classroom_id INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    message VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_classroom_id
        FOREIGN KEY (classroom_id)
        REFERENCES classrooms(classroom_id)
)

CREATE TABLE IF NOT EXISTS discussionforum (
    discussion_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    classroom_id INT NOT NULL,
    reply_to_id INT,
    title VARCHAR(50), -- assuming replies to existing threads does not require new titles.
    message VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_classroom_id
        FOREIGN KEY (classroom_id)
        REFERENCES classrooms(classroom_id)
)

-- Sett inn testdata
INSERT INTO users (first_name, last_name, email, role) VALUES
    ('Hans', 'Hanssen','hanshanssen@oslomet.no', 'teacher'),
    ('Ola', 'Nordmann', 'olanordmann@oslomet.no', 'student')
ON CONFLICT DO NOTHING;

-- Create classroom TestClassroom owned by user 1 (Hans Hanssen)
INSERT INTO classrooms (classroom_owner_id, classroom_name, classroom_code) VALUES
    (1, 'TestClassroom', 'T35T')
ON CONFLICT DO NOTHING;

-- Gives user id 2 (Ola Nordmann) access to classroom id 1 (TestClassroom)
INSERT INTO groups (user_id, classroom_id) VALUES
    (2, 1)
ON CONFLICT DO NOTHING;

-- Write a message from teacher to students
INSERT INTO messages (user_id, classroom_id, title, message) VALUES
    (2, 1, 'Important!', 'Exam is on 20th of may!')
ON CONFLICT DO NOTHING;

-- Create a discussion forum with nested chat
INSERT INTO discussionforum (user_id, classroom_id, reply_to_id, title, message) VALUES
    (2, 1, NULL, 'Question 1', 'How do we answer question 1?'),
    (1, 1, 1, NULL, 'Push your code to git.'),
    (2, 1, 2, NULL, 'Thanks for the response.')
ON CONFLICT DO NOTHING;

-- Vis at initialisering er fullført
SELECT 'Database initialisert!' as status;