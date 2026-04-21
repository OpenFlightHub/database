CREATE TABLE "users" (
  "id" serial PRIMARY KEY NOT NULL,
  "team_id" integer,
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

CREATE TABLE "teams" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "owner_user_id" integer NOT NULL,
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
  "created_by" integer NOT NULL,
  "has_thumbnail" boolean NOT NULL DEFAULT false,
  "thumbnail_generation_has_failed" boolean NOT NULL DEFAULT false,
  "exif_data" text,
  "exif_data_generation_has_failed" boolean NOT NULL DEFAULT false
);

CREATE TABLE "workspaces" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "longitude" float8 NOT NULL,
  "latitude" float8 NOT NULL
);

CREATE TABLE "workspace_permissions" (
  "team_id" integer NOT NULL,
  "workspace_id" integer NOT NULL,
  PRIMARY KEY ("team_id", "workspace_id")
);

CREATE TABLE "connections" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "secret" text NOT NULL,
  "session_token" text,
  "workspace_id" integer NOT NULL,
  "workspace_uuid" text UNIQUE NOT NULL,
  "remote_controller_id" integer,
  "last_drone_id" integer,
  "stream_is_alive" boolean NOT NULL DEFAULT false
);

CREATE TABLE "remote_controllers" (
  "id" serial PRIMARY KEY NOT NULL,
  "serial_number" text UNIQUE NOT NULL,
  "type" integer NOT NULL DEFAULT 0
);

CREATE TABLE "drones" (
  "id" serial PRIMARY KEY NOT NULL,
  "serial_number" text UNIQUE NOT NULL,
  "name" text NOT NULL,
  "type" integer NOT NULL DEFAULT 0,
  "last_connection_id" integer,
  "current_flight_id" integer,
  "in_flight" boolean NOT NULL DEFAULT false
);

CREATE TABLE "flights" (
  "id" serial PRIMARY KEY NOT NULL,
  "drone_id" integer NOT NULL,
  "workspace_id" integer NOT NULL,
  "started_at" timestamptz NOT NULL DEFAULT (now()),
  "landed_at" timestamptz,
  "ended_at" timestamptz
);

CREATE TABLE "flight_data" (
  "id" serial PRIMARY KEY NOT NULL,
  "flight_id" integer NOT NULL,
  "received_at" timestamptz NOT NULL DEFAULT (now()),
  "created_at" timestamptz NOT NULL,
  "type" integer NOT NULL,
  "data" jsonb NOT NULL
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
  "flight_id" integer NOT NULL,
  "type" integer NOT NULL DEFAULT 0,
  "data" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "drone_media" (
  "id" serial PRIMARY KEY NOT NULL,
  "drone_id" integer NOT NULL,
  "flight_id" integer NOT NULL,
  "type" integer NOT NULL,
  "file_id" integer NOT NULL,
  "fingerprint" text NOT NULL,
  "tiny_fingerprint" text NOT NULL,
  "meta" text,
  "captured_at" timestamptz,
  "received_at" timestamptz NOT NULL DEFAULT (now()),
  "coverage" text,
  "coverage_generated_at" timestamptz NOT NULL DEFAULT (now()),
  "camera_location" text,
  "camera_angles" text
);

CREATE TABLE "geo_objects" (
  "id" serial PRIMARY KEY NOT NULL,
  "uuid" text UNIQUE NOT NULL DEFAULT (uuid_generate_v4()),
  "workspace_id" integer NOT NULL,
  "name" text NOT NULL,
  "type" integer NOT NULL,
  "sub_type" integer NOT NULL,
  "config" json NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now())
);

COMMENT ON COLUMN "users"."state" IS '0 = invited, 1 = live, 2 = locked, 3 = deleted';

COMMENT ON COLUMN "teams"."state" IS '0 = invited, 1 = live, 2 = locked, 3 = deleted';

COMMENT ON COLUMN "remote_controllers"."type" IS '0 = unknown, 1 = dji rc plus, 2 = dji rc pro enterprise, 3 = dji rc plus 2, 4 = dji smart controller';

COMMENT ON COLUMN "drones"."type" IS '0 = unknown, 1 = dji matrice 300, 2 = dji matrice 30, 3 = dji matrice 350, 4 = dji mavic 3';

COMMENT ON COLUMN "flight_data"."type" IS '0 = position';

COMMENT ON COLUMN "remote_controller_data"."type" IS '0 = position';

COMMENT ON COLUMN "drone_data"."type" IS '0 = position, 1 = telemetry';

COMMENT ON COLUMN "drone_media"."type" IS '0 = video, 1 = picture, 2 = panorama';

COMMENT ON TABLE "geo_objects" IS '[TypescriptType]=

export type DBType_Geo_Object = DBType_Geo_Object_Base<0, 0> | DBType_Geo_Object_Base<0, 1> | DBType_Geo_Object_Base<0, 2> | DBType_Geo_Object_Base<0, 3> |
DBType_Geo_Object_Base<1, 0> | DBType_Geo_Object_Base<1, 1> | DBType_Geo_Object_Base<1, 2> | DBType_Geo_Object_Base<1, 3> | DBType_Geo_Object_Base<1, 4> |
DBType_Geo_Object_Base<2, 0> | DBType_Geo_Object_Base<2, 1> | DBType_Geo_Object_Base<2, 2> | DBType_Geo_Object_Base<2, 3> | DBType_Geo_Object_Base<2, 4> | DBType_Geo_Object_Base<2, 5> | DBType_Geo_Object_Base<2, 6>

export type DBType_Geo_Object_Base<type extends DBType_Geo_Object_TypeType, sub_type extends DBType_Geo_Object_SubTypeType<type>> = {
    id: number;
    uuid: string;
    workspace_id: number;
    name: string;
    type: type;
    sub_type: sub_type;
    config: DBType_Geo_Object_ConfigType<type, sub_type>;
    created_at: string;
    updated_at: string;
}


export type DBType_Geo_Object_TypeType = 0|1|2

export const DBType_Geo_Object_Type_TYPES = {
  marking: 0,
  traffic: 1,
  unit: 2
} as const

export type DBType_Geo_Object_SubTypeType<type extends DBType_Geo_Object_TypeType> =
    type extends 0 ? (0|1|2|3) :
    type extends 1 ? (0|1|2|3|4|5) :
    type extends 2 ? (0|1|2|3|4|5|6) : unknown


export const DBType_Geo_Object_SubType_TYPES = {
  marking: {
    point: 0,
    line: 1,
    polygon: 2,
    circle: 3
  },
  traffic: {
    airplane: 0,
    helicopter: 1,
    uav: 2,
    gliding: 3,
    other: 4
  },
  unit: {
    airplane: 0,
    helicopter: 1,
    uav: 2,
    pilot: 3,
    ground_vehicle: 4,
    ground_staff: 5,
    other: 6
  }
} as const

export type DBType_Geo_Object_ConfigType<type extends DBType_Geo_Object_TypeType, sub_type extends DBType_Geo_Object_SubTypeType<type>> = type extends 0 ? (
    sub_type extends 0 ? {point: [number, number, number], color: string} :
    sub_type extends 1 ? {line: [number, number, number][], color: string} :
    sub_type extends 2 ? {polygon: [number, number, number][], color: string} :
    sub_type extends 3 ? {center: [number, number, number], radius: number, color: string} : unknown
) : type extends 1 ? (
    {longitude: number, latitude: number, height: number, heading?: number, speed?: number}
) : type extends 2 ? (
    {longitude: number, latitude: number, symbol: string, height?: number, heading?: number, speed?: number}
) : unknown

  ';

ALTER TABLE "users" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "teams" ADD FOREIGN KEY ("owner_user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "files" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "files" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "workspace_permissions" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "workspace_permissions" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "connections" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "connections" ADD FOREIGN KEY ("remote_controller_id") REFERENCES "remote_controllers" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "connections" ADD FOREIGN KEY ("last_drone_id") REFERENCES "drones" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drones" ADD FOREIGN KEY ("last_connection_id") REFERENCES "connections" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drones" ADD FOREIGN KEY ("current_flight_id") REFERENCES "flights" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "flights" ADD FOREIGN KEY ("drone_id") REFERENCES "drones" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "flights" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "flight_data" ADD FOREIGN KEY ("flight_id") REFERENCES "flights" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "remote_controller_data" ADD FOREIGN KEY ("remote_controller_id") REFERENCES "remote_controllers" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drone_data" ADD FOREIGN KEY ("drone_id") REFERENCES "drones" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drone_data" ADD FOREIGN KEY ("flight_id") REFERENCES "flights" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drone_media" ADD FOREIGN KEY ("drone_id") REFERENCES "drones" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drone_media" ADD FOREIGN KEY ("file_id") REFERENCES "files" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "drone_media" ADD FOREIGN KEY ("flight_id") REFERENCES "flights" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "geo_objects" ADD FOREIGN KEY ("workspace_id") REFERENCES "workspaces" ("id") DEFERRABLE INITIALLY IMMEDIATE;
