--! Previous: sha1:360bc4738836eb8cc109e953b7429c2ea66c5380
--! Hash: sha1:557f01edb9265e75ee8fcc6dc133957321f1bd45

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TYPE secretsanta.jwt_token as (role text, session uuid);

CREATE OR REPLACE FUNCTION secretsanta.create_session(description text DEFAULT 'Unnamed Session') RETURNS secretsanta.jwt_token as $$
	declare
		session uuid;
	begin
		insert into auth.session (description) values (description) returning id into session;
		return ('user', session)::secretsanta.jwt_token;
	end;
$$ language plpgsql strict security definer;

GRANT SELECT on secretsanta.profile to "user";

CREATE OR REPLACE FUNCTION secretSanta.current_session() RETURNS auth.session as $$
	select * from auth.session as sess where sess.id = NULLIF(current_setting('jwt.claims.session', true), '')::uuid;
	$$ language sql stable security definer;

  create or replace function secretSanta.current_user() returns auth.user as $$
declare
	sess auth.session;
begin
	select secretSanta.current_session() into sess;
	select * from auth.user where sess.user = id;
end;
$$ language plpgsql stable security invoker;

create or replace function secretSanta.current_profile() returns secretSanta.profile as $$
declare
	sess bigint;
	currentprofile secretsanta.profile;
begin
	select "user" from  secretSanta.current_session() into sess;
	select * from secretsanta.profile as profile where profile."user" = sess into currentprofile;
	return currentprofile;
end;
$$ language plpgsql stable security definer;
