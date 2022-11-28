--! Previous: sha1:028646883eebb8bbd2c0443619616f2562df1208
--! Hash: sha1:91bbd64de3391a6fdadf57e451ff198d06da11f2

GRANT SELECT ON secretsanta.message TO "user";

ALTER TABLE secretsanta.message ENABLE ROW LEVEL SECURITY;

CREATE POLICY allow_read_matchup_messages
	ON secretsanta.message
	FOR SELECT
	USING
		(matchup in (select matchup from secretsanta.matchup where recipient = secretsanta.current_profile_id() or sender = secretsanta.current_profile_id()));
