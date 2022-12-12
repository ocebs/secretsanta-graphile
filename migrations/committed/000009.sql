--! Previous: sha1:d27c5be7f345126733debec36e2ca6f1fb9b14c9
--! Hash: sha1:b832aeea6d06613a401ce56c937810448635c942

-- Enter migration here
COMMENT ON TABLE "secretsanta"."country" IS '@omit create,update,delete';
alter table secretsanta.message rename column sender to sender_id;
alter table secretsanta.profile rename column country to country_id;
alter table secretsanta.matchup rename column recipient to recipient_id;
alter table secretsanta.matchup rename column sender to sender_id;
alter table auth.session rename column "user" to user_id;
alter table secretsanta.profile rename column "user" to user_id;
CREATE OR REPLACE FUNCTION secretsanta.current_profile()
   RETURNS secretsanta.profile
  LANGUAGE plpgsql
 STABLE SECURITY DEFINER
AS $function$
declare
	sess bigint;
	currentprofile secretsanta.profile;
begin
	select user_id from  secretSanta.current_session() into sess;
	select * from secretsanta.profile as profile where profile.user_id = sess into currentprofile;
	return currentprofile;
end;
$function$;
