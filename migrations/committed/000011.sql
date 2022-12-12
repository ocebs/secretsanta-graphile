--! Previous: sha1:d33788a1190eb4b13e66d7131985a0f78a8b5fa0
--! Hash: sha1:100476499aceac6decc46030a04b97072f93e61a

DROP POLICY allow_read_matchup_messages
	ON secretsanta.message;
CREATE POLICY allow_read_matchup_messages
	ON secretsanta.message
	FOR SELECT
	USING
		(matchup in (select id from secretsanta.matchup where recipient_id = secretsanta.current_profile_id() or sender_id = secretsanta.current_profile_id()));
