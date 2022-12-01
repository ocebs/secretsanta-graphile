--! Previous: sha1:f091ab1d2456b4c666dd2c765b18a17aa9e3ffa0
--! Hash: sha1:848d82d744b4b47398de48fd0fd3b55258b5091d

ALTER TABLE secretsanta.message ENABLE ROW LEVEL SECURITY;

GRANT
INSERT
  on secretsanta.message to "user";

CREATE POLICY allow_send_messages ON secretsanta.message FOR
INSERT
  WITH CHECK (sender = secretsanta.current_profile_id() AND (
    (
      secretsanta.current_profile_id() in (
        select
          sender
        from
          secretsanta.matchup
        where
          id = matchup
      )
      OR (
        secretsanta.current_profile_id() in (
          select
            recipient
          from
            secretsanta.matchup
          where
            id = matchup
        )
      )
    )
  ));
