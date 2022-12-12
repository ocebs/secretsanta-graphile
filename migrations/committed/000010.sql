--! Previous: sha1:b832aeea6d06613a401ce56c937810448635c942
--! Hash: sha1:d33788a1190eb4b13e66d7131985a0f78a8b5fa0

ALTER TYPE secretsanta.jwt_token ADD ATTRIBUTE exp integer;

CREATE OR REPLACE FUNCTION secretsanta.create_session(description text DEFAULT 'Unnamed Session')
   RETURNS secretsanta.jwt_token
  LANGUAGE plpgsql
 STRICT SECURITY DEFINER
AS $function$
	declare
		session uuid;
	begin
		insert into auth.session (description) values (description) returning id into session;
		return ('user', session, extract(epoch from (now() + interval '6 months')))::secretsanta.jwt_token;
	end;
$function$;
