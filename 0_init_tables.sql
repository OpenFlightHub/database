CREATE TABLE "users" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "email_hash" text NOT NULL,
  "password" text,
  "login_token" text,
  "session_token" text,
  "stream_token" text,
  "reset_code" text,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "state" integer NOT NULL DEFAULT 0,
  "locale" text NOT NULL DEFAULT 'en-US'
);

CREATE TABLE "files" (
  "id" serial PRIMARY KEY NOT NULL,
  "workspace_id" integer NOT NULL,
  "ext" text NOT NULL,
  "name" text NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "created_by" integer NOT NULL
);

CREATE TABLE "workspaces" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL
);

CREATE TABLE "workspace_permissions" (
  "user_id" integer NOT NULL,
  "workspace_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "workspace_id")
);

CREATE TABLE "connections" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "secret" text NOT NULL,
  "session_token" text,
  "workspace_id" integer NOT NULL,
  "workspace_uuid" text NOT NULL,
  "remote_controller_id" integer,
  "last_drone_id" integer
);

CREATE TABLE "remote_controllers" (
  "id" serial PRIMARY KEY NOT NULL,
  "serial_number" text NOT NULL,
  "type" integer NOT NULL DEFAULT 0
);

CREATE TABLE "drones" (
  "id" serial PRIMARY KEY NOT NULL,
  "serial_number" text NOT NULL,
  "name" text NOT NULL,
  "type" integer NOT NULL DEFAULT 0,
  "last_connection_id" integer
);

CREATE TABLE "remote_controller_data" (
  "id" serial PRIMARY KEY NOT NULL,
  "remote_controller_id" integer NOT NULL,
  "type" integer NOT NULL DEFAULT 0,
  "data" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "drone_data" (
  "id" serial PRIMARY KEY NOT NULL,
  "drone_id" integer NOT NULL,
  "type" integer NOT NULL DEFAULT 0,
  "data" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "drone_media" (
  "id" serial PRIMARY KEY NOT NULL,
  "drone_id" integer NOT NULL,
  "type" integer NOT NULL,
  "file_id" integer NOT NULL,
  "fingerprint" text NOT NULL,
  "tiny_fingerprint" text NOT NULL,
  "meta" text
);

COMMENT ON COLUMN "users"."state" IS '0 = invited, 1 = live, 2 = locked, 3 = deleted';

COMMENT ON COLUMN "remote_controllers"."type" IS '0 = unknown, 1 = dji rc plus, 2 = dji rc pro enterprise';

COMMENT ON COLUMN "drones"."type" IS '0 = unknown, 1 = dji matrice 300, 2 = dji matrice 30, 3 = dji matrice 350, 4 = dji mavic 3';

COMMENT ON COLUMN "remote_controller_data"."type" IS '0 = todo';

COMMENT ON COLUMN "drone_data"."type" IS '0 = position, 1 = telemetry';

COMMENT ON COLUMN "drone_media"."type" IS '0 = video, 1 = picture, 2 = panorama';

ALTER TABLE "files" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id");

ALTER TABLE "files" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id");

ALTER TABLE "workspace_permissions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "workspace_permissions" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id");

ALTER TABLE "connections" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id");

ALTER TABLE "connections" ADD FOREIGN KEY ("remote_controller_id") REFERENCES "remote_controllers" ("id");

ALTER TABLE "connections" ADD FOREIGN KEY ("last_drone_id") REFERENCES "drones" ("id");

ALTER TABLE "drones" ADD FOREIGN KEY ("last_connection_id") REFERENCES "connections" ("id");

ALTER TABLE "remote_controller_data" ADD FOREIGN KEY ("remote_controller_id") REFERENCES "remote_controllers" ("id");

ALTER TABLE "drone_data" ADD FOREIGN KEY ("drone_id") REFERENCES "drones" ("id");

ALTER TABLE "drone_media" ADD FOREIGN KEY ("drone_id") REFERENCES "drones" ("id");

ALTER TABLE "drone_media" ADD FOREIGN KEY ("file_id") REFERENCES "files" ("id");
