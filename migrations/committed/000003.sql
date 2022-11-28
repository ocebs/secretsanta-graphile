--! Previous: sha1:557f01edb9265e75ee8fcc6dc133957321f1bd45
--! Hash: sha1:eddc8e3fbf755b5afbfeab990901ef61ea725313

CREATE OR REPLACE FUNCTION secretsanta.current_profile_id()
 RETURNS uuid
 LANGUAGE sql
 STABLE
AS $function$
select id from secretsanta.current_profile();
$function$
;

ALTER TABLE secretsanta.matchup ENABLE ROW LEVEL SECURITY;

CREATE POLICY allow_read_own_matchups 
  ON secretsanta.matchup FOR SELECT 
  USING 
    (sender = secretsanta.current_profile_id()
      OR recipient = secretsanta.current_profile_id());

ALTER TABLE secretsanta.profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY allow_read_own_profile
  ON secretsanta.profile FOR SELECT 
  USING
    (id = secretsanta.current_profile_id());

CREATE POLICY allow_read_sending_profile
  ON secretsanta.profile FOR SELECT 
  USING
    (id in (select recipient from secretsanta.matchup where sender = secretsanta.current_profile_id()));
