
-- users #0 (the system user)
INSERT INTO users (id, name, email, email_hash) VALUES (0, 'system', '', '');

-- users #1 (for example usage) password = 1234
INSERT INTO users (id, name, email, email_hash, password) VALUES (1, 'test', 'test@openflighthub.org', '', '64$65536$8$1$o01tZR9QKBZbfXHtgCsHjSJfWHZwitNYhuYKGYO8RVQ=$55PAX9JDYsNPGNFXOOgdCNeZ7A/tPYD5jHvFoMbqw7BlJN+HY3g1cO9X/Nt5uHevNBidUBQOKDSWlCNbVPBDKg==');

-- users #2 (for api tests) password = CorrectBatteryHorseStaple
INSERT INTO users (id, name, email, email_hash, password, session_token) VALUES (2, 'test_api_1', 'test_api_1@openflighthub.org', '', '64$65536$8$1$Gd6jprqm68qOQeRotxmLCZYGLZRMjdbZNluI4CsqEA4=$0auLNnLn1/q/fSdI96LuhyP4shW77BrWRoA1h0JS+hpP1YTCEJ0uQa71vikAn8a2ozN25qpuKtpzZ5FHsj60+A==', 'session_2');

-- users #3 (for api tests) password = CorrectBatteryHorseStaple
INSERT INTO users (id, name, email, email_hash, password, login_token) VALUES (3, 'test_api_2', 'test_api_2@openflighthub.org', '', '64$65536$8$1$Gd6jprqm68qOQeRotxmLCZYGLZRMjdbZNluI4CsqEA4=$0auLNnLn1/q/fSdI96LuhyP4shW77BrWRoA1h0JS+hpP1YTCEJ0uQa71vikAn8a2ozN25qpuKtpzZ5FHsj60+A==', '39s7h17sd76g1sd');

-- users #4 dev account password = ofh
INSERT INTO users (id, name, email, email_hash, password) VALUES (4, 'Dev', 'mail@openflighthub.org', '', '64$65536$8$1$lk/s/aij4pLpEFK7eF2iIkFD1vxNYpipvVz9uTBqJUI=$ouhy3I2GXduGM8m8HY1/XszNonxy7oYJYnv9lx6BcfUH2AKUxgfeM9qnAVuSs9cYjaFDuN0Awt8RHjBOkgnhLg==');

-- users #5 (for example usage) password = CorrectBatteryHorseStaple
INSERT INTO users (id, name, email, email_hash, password) VALUES (5, 'edp', 'edp@openflighthub.org', '', '64$65536$8$1$Gd6jprqm68qOQeRotxmLCZYGLZRMjdbZNluI4CsqEA4=$0auLNnLn1/q/fSdI96LuhyP4shW77BrWRoA1h0JS+hpP1YTCEJ0uQa71vikAn8a2ozN25qpuKtpzZ5FHsj60+A==');


-- workspaces #1
INSERT INTO workspaces (id, name, longitude, latitude) VALUES (1, 'Test Usage Example', 10.270800, 47.563710);
-- grant permissions for user 1
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (1, 1);
-- grant permissions for user 4
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (1, 4);
-- grant permissions for user 5
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (1, 5);


-- remote_controllers #1
INSERT INTO remote_controllers (id, serial_number) VALUES (1, 'RC_FAKE');

-- drones #1
INSERT INTO drones (id, serial_number, name) VALUES (1, 'DRONE_FAKE', 'Fake Mavic 3');

-- flights #1
INSERT INTO flights (id, drone_id) VALUES (1, 1);

UPDATE drones SET current_flight_id = 1 WHERE id = 1;

-- connections #1
INSERT INTO connections (id, secret, name, workspace_id, last_drone_id, remote_controller_id, workspace_uuid) VALUES (1, 'fake', 'con1', 1, 1, 1, 'a1491fa4-1afc-4f4b-8705-32ee5d28cc7d');

UPDATE drones SET last_connection_id = 1 WHERE id = 1;

-- remote_controller_data #1
INSERT INTO remote_controller_data (id, remote_controller_id, type, data) VALUES (1, 1, 0, '{"height": 1051.7, "latitude": 47.53882, "longitude": 10.32101}'::json);



-- workspaces #2
INSERT INTO workspaces (id, name, longitude, latitude) VALUES (2, 'Some Workspace', 10.294488, 47.629693);
-- grant permissions for user 4
INSERT INTO workspace_permissions (workspace_id, user_id) VALUES (2, 4);


-- remote_controllers #2
INSERT INTO remote_controllers (id, serial_number) VALUES (2, 'RC_EXAMPLE');

-- drones #2
INSERT INTO drones (id, serial_number, name) VALUES (2, 'DRONE_EXAMPLE', 'Example Mavic 3');

-- flights #2
INSERT INTO flights (id, drone_id) VALUES (2, 2);

UPDATE drones SET current_flight_id = 2 WHERE id = 2;

-- connections #2
INSERT INTO connections (id, secret, name, workspace_id, last_drone_id, remote_controller_id, workspace_uuid) VALUES (2, 'access', 'con2', 2, 2, 2, '65fefa14-0fcb-4166-93db-583ef9fd6811');

UPDATE drones SET last_connection_id = 2 WHERE id = 2;

-- remote_controller_data #2
INSERT INTO remote_controller_data (id, remote_controller_id, type, data) VALUES (2, 2, 0, '{"height": 738.1, "latitude": 47.558801, "longitude": 10.285472}'::json);

-- drone_data #1
INSERT INTO drone_data (id, drone_id, flight_id, type, data) VALUES (1, 2, 2, 0, '{"height": 802.2, "latitude": 47.558801, "longitude": 10.283472}'::json);


-- files #1
INSERT INTO files (id, workspace_id, name, ext, created_by) VALUES (1, 1, 'DJI_20230608135046_0004_T.JPG', 'JPG', 1);
INSERT INTO files (id, workspace_id, name, ext, created_by) VALUES (2, 1, 'DJI_20230608135032_0003_W.JPG', 'JPG', 1);

-- drone_media #1
INSERT INTO drone_media (id, drone_id, flight_id, type, file_id, fingerprint, tiny_fingerprint, meta) VALUES (1, 1, 1, 1, 1, 'example_fingerprint', 'example_tiny_fingerprint', '{"ext":{"drone_model_key":"0-77-1","file_group_id":"","is_original":true,"line_name":"","payload_model_key":"1-67-0","shoot_position":0,"sn":"1581F5FJC246300E82TU","task_name":"","tinny_fingerprint":"38d9729c9c99ca866cb5e2a0937bce55_2025_4_8_23_19_16"},"metadata":{"absolute_altitude":1799.156,"created_time":"2025-04-08T23:19:17+08:00","gimbal_yaw_degree":136.4,"photoed_position":{"lat":0,"lng":0},"relative_altitude":0,"shoot_position":{"lat":47.53088863888889,"lng":10.18527063888889}}}'::json);

-- drone_media #2
INSERT INTO drone_media (id, drone_id, flight_id, type, file_id, fingerprint, tiny_fingerprint, meta) VALUES (2, 1, 1, 1, 2, 'example_fingerprint', 'example_tiny_fingerprint', '{"ext":{"drone_model_key":"0-77-1","file_group_id":"","is_original":true,"line_name":"","payload_model_key":"1-67-0","shoot_position":0,"sn":"1581F5FJC246300E82TU","task_name":"","tinny_fingerprint":"6e7156ee371bfea974d78fcc551cb4d2_2025_4_8_23_19_16"},"metadata":{"absolute_altitude":1799.357,"created_time":"2025-04-08T23:19:17+08:00","gimbal_yaw_degree":136.6,"photoed_position":{"lat":0,"lng":0},"relative_altitude":0,"shoot_position":{"lat":47.53088863888889 ,"lng":10.18527063888889}}}'::json);


-- FIX all id sequences
SELECT setval('users_id_seq', 5, true);
SELECT setval('workspaces_id_seq', 2, true);
SELECT setval('remote_controllers_id_seq', 2, true);
SELECT setval('drones_id_seq', 2, true);
SELECT setval('flights_id_seq', 2, true);
SELECT setval('connections_id_seq', 2, true);
SELECT setval('remote_controller_data_id_seq', 2, true);
SELECT setval('drone_data_id_seq', 1, true);
SELECT setval('files_id_seq', 2, true);
SELECT setval('drone_media_id_seq', 2, true);


