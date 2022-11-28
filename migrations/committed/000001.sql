--! Previous: -
--! Hash: sha1:360bc4738836eb8cc109e953b7429c2ea66c5380

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS "auth";

CREATE TABLE auth.user (
  id bigint PRIMARY KEY,
  lastlogin timestamp without time zone,
  role text DEFAULT 'user' :: text
);

CREATE SCHEMA IF NOT EXISTS "secretsanta";

GRANT USAGE on SCHEMA "secretsanta" to nologin;

CREATE TABLE auth.session (
  id uuid DEFAULT uuid_generate_v1() PRIMARY KEY,
  timestamp timestamp without time zone NOT NULL DEFAULT now(),
  "user" bigint REFERENCES auth."user"(id) ON DELETE
  SET
    NULL ON UPDATE CASCADE,
    description text
);

CREATE TABLE secretsanta.country (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE
);

ALTER TABLE
  secretsanta.country ENABLE ROW LEVEL SECURITY;

CREATE POLICY allow_read_countries ON secretsanta.country FOR
SELECT
  USING (true);

GRANT
SELECT
  on secretsanta.country TO nologin;

INSERT INTO
  secretsanta.country (name)
values
  ('Australia'),
  ('New Zealand');

CREATE TABLE secretsanta.profile (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "user" bigint REFERENCES auth."user"(id) ON DELETE CASCADE ON UPDATE CASCADE UNIQUE,
  name text,
  bio text,
  address text,
  country integer DEFAULT 1 REFERENCES secretsanta.country(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE secretsanta.matchup (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  sender uuid REFERENCES secretsanta.profile(id) ON DELETE
  SET
    NULL ON UPDATE CASCADE,
    recipient uuid REFERENCES secretsanta.profile(id) ON DELETE
  SET
    NULL ON UPDATE CASCADE
);

CREATE TABLE secretsanta.message (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  sender uuid REFERENCES secretsanta.profile(id) ON DELETE CASCADE ON UPDATE CASCADE,
  timestamp timestamp without time zone DEFAULT now(),
  message text DEFAULT '' :: text,
  matchup uuid REFERENCES secretsanta.matchup(id) ON DELETE CASCADE ON UPDATE CASCADE
);

GRANT
SELECT
,
INSERT
  on secretsanta.message to "user";

ALTER TABLE
  secretsanta.message ENABLE ROW LEVEL SECURITY;
