BEGIN;

DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS resource CASCADE;
DROP TABLE IF EXISTS connection_request CASCADE;
DROP TABLE IF EXISTS job_posting CASCADE;
DROP TYPE IF EXISTS enrollment_type CASCADE;
DROP TABLE IF EXISTS event CASCADE;

CREATE TYPE enrollment_type AS ENUM (
    'Current Student',
    'Alum',
    'Staff'
);

CREATE TYPE approval_status AS ENUM (
    'Not Reviewed',
    'Approved',
    'Rejected'
);

CREATE TABLE account(
    id BIGSERIAL PRIMARY KEY,
    deactivated BOOLEAN NOT NULL DEFAULT FALSE,
    email TEXT NOT NULL,
    password_digest TEXT NOT NULL,
    password_salt TEXT NOT NULL,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_initial TEXT NOT NULL,
    enrollment_type enrollment_type NULL, -- null if the user is neither a current student nor an alum
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    bio TEXT NULL,
    role TEXT NULL,
    current_school TEXT NULL,
    current_company TEXT NULL
);

CREATE UNIQUE INDEX account_email ON account(LOWER(email));

-- password for this account is just 'password'
INSERT INTO account(email, password_digest, password_salt, first_name, last_name, last_initial, enrollment_type, is_admin) VALUES(
    'test@example.com',
    '$2b$12$KuZta9JGWDgtd05EPbm8M.lYMex0jyOLhUSBbjEU3pm0N9SQaJGUG',
    '$2b$12$KuZta9JGWDgtd05EPbm8M.',
    'Test',
    'Account',
    'A',
    NULL,
    TRUE
);

CREATE TABLE resource(
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    provider_id BIGINT REFERENCES account(id),
    location TEXT NULL
);

CREATE TABLE connection_request(
    id BIGSERIAL PRIMARY KEY,

    -- has an admin resolved this request
    resolved BOOLEAN NOT NULL DEFAULT FALSE,

    -- the member DOING the requesting
    requester_id BIGINT REFERENCES account(id) NOT NULL,

    -- the member from whom something is being requestd
    requestee_id BIGINT REFERENCES account(id) NOT NULL,

    -- a brief message explaining the request (optional)
    requester_message TEXT NOT NULL,

    CREATED TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE event(
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    organizer_id BIGINT REFERENCES account(id) NOT NULL,
    description TEXT NULL,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    approval_status approval_status NOT NULL DEFAULT 'Not Reviewed'
);

CREATE TABLE job_posting(
  id BIGSERIAL PRIMARY KEY,

  -- has an admin confirm this posting
  approval_status approval_status NOT NULL DEFAULT 'Not Reviewed',

  -- the member posting the job
  poster_id BIGINT REFERENCES account(id) NOT NULL,

  -- the job title on the posting
  title TEXT NOT NULL,

  -- the posting time for this job
  post_time DATE NOT NULL,

  -- the description for this job
  description TEXT NOT NULL,

  -- the working locationn for this job
  location TEXT NULL
);

COMMIT;
