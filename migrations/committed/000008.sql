--! Previous: sha1:848d82d744b4b47398de48fd0fd3b55258b5091d
--! Hash: sha1:d27c5be7f345126733debec36e2ca6f1fb9b14c9

GRANT UPDATE ("name", bio, address, country) ON secretsanta.profile TO "user";
ALTER TABLE secretsanta.profile ENABLE ROW LEVEL SECURITY;
CREATE POLICY allow_update_own_profile ON secretsanta.profile USING ("id" = secretsanta.current_profile_id()) WITH CHECK (true);
