
-- users #1 password = brainstem
INSERT INTO users (id, name, email, email_hash, password) VALUES (1, 'Admin', 'mail@openflighthub.org', '', '64$65536$8$1$lk/s/aij4pLpEFK7eF2iIkFD1vxNYpipvVz9uTBqJUI=$ouhy3I2GXduGM8m8HY1/XszNonxy7oYJYnv9lx6BcfUH2AKUxgfeM9qnAVuSs9cYjaFDuN0Awt8RHjBOkgnhLg==');


-- workspaces #1
INSERT INTO workspaces (id, name) VALUES (1, 'Test');
-- grant permissions for user 1
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (1, 1);


-- workspaces #2
INSERT INTO workspaces (id, name) VALUES (2, 'Shared');
-- grant permissions for user 1
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (2, 1);


-- remote_controllers #1
INSERT INTO remote_controllers (id, serial_number) VALUES (1, 'RC_EXAMPLE');

-- drones #1
INSERT INTO drones (id, serial_number, name) VALUES (1, 'DRONE_EXAMPLE', 'Example Mavic 3');

-- connections #1
INSERT INTO connections (id, access_key, workspace_id, drone_id, remote_controller_id) VALUES (1, 'access', 1, 1, 1);



-- FIX all id sequences
SELECT setval('users_id_seq', 1, true);
SELECT setval('workspaces_id_seq', 2, true);
SELECT setval('remote_controllers_id_seq', 1, true);
SELECT setval('drones_id_seq', 1, true);
SELECT setval('connections_id_seq', 1, true);


