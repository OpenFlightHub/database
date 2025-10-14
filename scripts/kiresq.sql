-- users #6 (for example usage) password = tegelberg
INSERT INTO users (name, email, email_hash, password) VALUES ('kiresq', 'kiresq@openflighthub.org', '', '64$65536$8$1$CZf4OUu+NtC59qyE8YHN2S+pQusU6922vGS+gp42vFc=$Gtm463WkGw0VJufd/YbtBvhh+lLyK1ZiXmUwHIptLffqtuKq1oebBf2/W1mstmkb2qHQGrmwvXaRsuA3/vJ57g==');


-- workspaces #3
INSERT INTO workspaces (name) VALUES ('KIresQ');
-- grant permissions for user 6
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (3, 6);
-- grant permissions for user 4
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (3, 4);
